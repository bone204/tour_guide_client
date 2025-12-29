import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_guide_app/common/constants/app_route.constant.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/common/widgets/dialog/custom_dialog.dart';
import 'package:tour_guide_app/core/config/lang/arb/app_localizations.dart';
import 'package:tour_guide_app/core/network/logger_interceptor.dart';
import 'package:tour_guide_app/main.dart';

class DioClient {
  late final Dio dio;
  final SharedPreferences prefs;

  // --- STATE VARIABLES ---

  // 1. Biến để chống duplicate dialog khi mất mạng (Concurrency Handling)
  // Nếu != null nghĩa là đang có 1 dialog mất mạng đang hiển thị.
  Future<bool>? _retryConnectionFuture;

  // 2. Biến để chống duplicate request khi refresh token
  Future<bool>? _refreshTokenFuture;

  bool _isExitingApp = false;
  bool _isLoggingOut = false;

  DioClient(this.prefs) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiUrls.baseURL,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        validateStatus:
            (status) => status != null && status >= 200 && status < 300,
        contentType: Headers.jsonContentType,
      ),
    );

    // --- INTERCEPTORS SETUP ---

    // 1. Logger (Chạy đầu tiên khi request, cuối cùng khi response/error)
    dio.interceptors.add(LoggerInterceptor());

    // 2. Connectivity Interceptor (Xử lý lỗi mạng & Retry)
    // Dùng InterceptorsWrapper thường để không khóa queue của Dio
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          // Kiểm tra lỗi mạng hoặc lỗi server không phản hồi
          String? errorTitle;
          String? errorContent;

          if (_isConnectionError(error)) {
            final context = navigatorKey.currentContext;
            if (context != null) {
              errorTitle = AppLocalizations.of(context)!.connectionLostTitle;
              errorContent =
                  AppLocalizations.of(context)!.connectionLostContent;
            }
          } else if (_isServerNoResponseError(error)) {
            final context = navigatorKey.currentContext;
            if (context != null) {
              errorTitle = AppLocalizations.of(context)!.serverNoResponseTitle;
              errorContent =
                  AppLocalizations.of(context)!.serverNoResponseContent;
            }
          }

          if (errorTitle != null && errorContent != null) {
            // [OPTIONAL] Xử lý cho API chạy ngầm (ví dụ Timer 30s)
            // Nếu request có cờ 'silent', bỏ qua dialog và trả về lỗi luôn.
            // Cách dùng: dio.get(url, options: Options(extra: {'silent': true}));
            final bool isSilent = error.requestOptions.extra['silent'] ?? false;
            if (isSilent) {
              return handler.next(error);
            }

            print(
              '⛔ Connectivity/Server issue detected: ${error.requestOptions.path}',
            );

            // --- LOGIC DEDUPING DIALOG ---
            // Thay vì showDialog trực tiếp, gọi qua hàm quản lý Future
            final shouldRetry = await _getRetryDecision(
              navigatorKey.currentContext,
              title: errorTitle,
              content: errorContent,
            );

            if (shouldRetry) {
              try {
                print('🔁 Retrying request: ${error.requestOptions.path}');
                // Gọi lại request (Recursive).
                // Nếu retry thất bại, nó sẽ lại chui vào onError này -> Check _getRetryDecision -> Join dialog cũ hoặc hiện mới.
                final response = await dio.fetch(error.requestOptions);
                return handler.resolve(response);
              } catch (e) {
                // Nếu retry sinh ra lỗi (thường là DioException), chuyển tiếp nó.
                return handler.next(e is DioException ? e : error);
              }
            }
          }

          // Không phải lỗi mạng/server hoặc user chọn Đóng
          return handler.next(error);
        },
      ),
    );

    // 3. Auth Interceptor (Token Injection & Refresh Token)
    // Dùng QueuedInterceptorsWrapper để xếp hàng các request khi đang Refresh
    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) {
          final accessToken = prefs.getString("accessToken");
          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $accessToken";
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;

          // Chỉ xử lý 401
          if (statusCode != 401) {
            return handler.next(error);
          }

          // Tránh loop nếu chính API refresh bị 401
          if (error.requestOptions.path.endsWith(ApiUrls.refreshToken)) {
            await _handleRefreshFailure(isTokenExpired: !_isLoggingOut);
            return handler.next(error);
          }

          print('🔒 401 Detected. Starting refresh token flow...');

          // --- LOGIC REFRESH TOKEN ---
          _refreshTokenFuture ??= _refreshToken();
          final refreshed = await _refreshTokenFuture!;
          _refreshTokenFuture = null;

          if (refreshed) {
            final newAccessToken = prefs.getString("accessToken");
            if (newAccessToken != null && newAccessToken.isNotEmpty) {
              // Update Header
              final newHeaders = Map<String, dynamic>.from(
                error.requestOptions.headers,
              );
              newHeaders["Authorization"] = "Bearer $newAccessToken";
              final newOptions = error.requestOptions.copyWith(
                headers: newHeaders,
              );

              try {
                // Retry request sau khi refresh thành công
                final response = await dio.fetch(newOptions);
                return handler.resolve(response);
              } catch (e) {
                return handler.next(e is DioException ? e : error);
              }
            }
          }

          // Refresh thất bại
          await _handleRefreshFailure(isTokenExpired: !_isLoggingOut);
          return handler.next(error);
        },
      ),
    );
  }

  // ===========================================================================
  // PRIVATE HELPER METHODS
  // ===========================================================================

  /// Quản lý việc hiển thị Dialog Mất kết nối để tránh hiển thị chồng chéo.
  Future<bool> _getRetryDecision(
    BuildContext? context, {
    required String title,
    required String content,
  }) async {
    if (context == null) return false;

    // 1. Nếu đang có dialog hiển thị (Future chưa hoàn thành), join vào nó.
    if (_retryConnectionFuture != null) {
      print(
        '⚠️ Dialog already showing. Request joining existing wait queue...',
      );
      return await _retryConnectionFuture!;
    }

    // 2. Nếu chưa có, tạo dialog mới và lưu Future lại.
    print('🆕 Showing new connectivity dialog...');
    _retryConnectionFuture = _showConnectivityDialogSimple(
      context,
      title: title,
      content: content,
    );

    // 3. Đợi kết quả từ người dùng.
    final result = await _retryConnectionFuture!;

    // 4. Clear biến Future để lần lỗi tiếp theo (nếu có) sẽ hiện dialog mới.
    // Dùng delay nhỏ để đảm bảo tất cả các request đang await ở bước 1 đều nhận được kết quả.
    Future.delayed(const Duration(milliseconds: 100), () {
      _retryConnectionFuture = null;
    });

    return result;
  }

  bool _isConnectionError(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        (error.error is SocketException) ||
        (error.message != null && error.message!.contains('SocketException'));
  }

  bool _isServerNoResponseError(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        (error.type == DioExceptionType.receiveTimeout) ||
        (error.type == DioExceptionType.sendTimeout);
  }

  Future<bool> _showConnectivityDialogSimple(
    BuildContext context, {
    required String title,
    required String content,
  }) async {
    // Ẩn bàn phím nếu đang mở
    FocusManager.instance.primaryFocus?.unfocus();

    final completer = Completer<bool>();

    await showAppDialog(
      context: context,
      title: title,
      content: content,
      icon: Icons.wifi_off,
      iconColor: Colors.redAccent,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (!completer.isCompleted) completer.complete(false); // Đóng
          },
          child: Text(AppLocalizations.of(context)!.close),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (!completer.isCompleted) completer.complete(true); // Thử lại
          },
          child: Text(AppLocalizations.of(context)!.retry),
        ),
      ],
    );

    return completer.future;
  }

  Future<bool> _refreshToken() async {
    final refreshToken = prefs.getString("refreshToken");
    if (refreshToken == null || refreshToken.isEmpty) return false;

    try {
      // Dùng instance Dio riêng để tránh dính interceptor của Dio chính
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: ApiUrls.baseURL,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final res = await refreshDio.post(
        ApiUrls.refreshToken,
        options: Options(headers: {"Authorization": "Bearer $refreshToken"}),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final newAccessToken = res.data?["accessToken"] as String?;
        final newRefreshToken = res.data?["refreshToken"] as String?;

        if ((newAccessToken ?? '').isNotEmpty &&
            (newRefreshToken ?? '').isNotEmpty) {
          await prefs.setString("accessToken", newAccessToken!);
          await prefs.setString("refreshToken", newRefreshToken!);
          print('✅ Token refreshed successfully');
          return true;
        }
      }
      return false;
    } catch (e) {
      print('❌ Refresh token error: $e');
      return false;
    }
  }

  Future<void> _handleRefreshFailure({bool isTokenExpired = true}) async {
    await prefs.remove("accessToken");
    await prefs.remove("refreshToken");

    if (_isLoggingOut || _isExitingApp) return;

    _isExitingApp = true;
    final context = navigatorKey.currentContext;

    if (context != null) {
      final currentRoute = ModalRoute.of(context)?.settings.name;
      final excludedRoutes = [
        AppRouteConstant.root,
        AppRouteConstant.splash,
        AppRouteConstant.signIn,
      ];

      if (!excludedRoutes.contains(currentRoute) && isTokenExpired) {
        await showAppDialog(
          context: context,
          title: AppLocalizations.of(context)!.sessionExpired,
          content: AppLocalizations.of(context)!.sessionExpiredMessage,
          icon: Icons.warning_amber_rounded,
          iconColor: Colors.orange,
          barrierDismissible: false,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout(context);
              },
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        );
      } else {
        _performLogout(context);
      }
    }

    // Reset flag sau một khoảng thời gian ngắn
    Future.delayed(const Duration(seconds: 1), () => _isExitingApp = false);
  }

  void _performLogout(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRouteConstant.signIn, (route) => false);
  }

  void setLoggingOut(bool isLoggingOut) {
    _isLoggingOut = isLoggingOut;
  }

  // ===========================================================================
  // HTTP WRAPPERS
  // ===========================================================================

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await dio.get(
      url,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await dio.post(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await dio.put(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<dynamic> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await dio.delete(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response> patch(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await dio.patch(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }
}
