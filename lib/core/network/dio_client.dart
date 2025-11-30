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

  Future<bool>? _refreshTokenFuture;

  DioClient(this.prefs) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiUrls.baseURL,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus:
            (status) => status != null && status >= 200 && status < 300,
      ),
    );

    dio.interceptors.addAll([
      LoggerInterceptor(),
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) {
          final accessToken = prefs.getString("accessToken");
          print('➡️ Request: ${options.method} ${options.path}');
          print('Headers before request: ${options.headers}');
          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $accessToken";
            print('Added Authorization header: Bearer $accessToken');
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final statusCode = error.response?.statusCode ?? 0;
          print('⚠️ Request error: $statusCode ${error.requestOptions.path}');
          if (error.response != null) {
            print('Error response data: ${error.response?.data}');
          }

          if (statusCode != 401) {
            return handler.next(error);
          }

          final isRefreshCall = error.requestOptions.path.endsWith(
            ApiUrls.refreshToken,
          );
          print('Is refresh token call: $isRefreshCall');
          if (isRefreshCall) {
            return handler.next(error);
          }

          // Refresh token
          _refreshTokenFuture ??= _refreshToken();
          final refreshed = await _refreshTokenFuture!;
          _refreshTokenFuture = null;

          if (!refreshed) {
            print('❌ Refresh token failed. Clearing tokens.');
            await prefs.remove("accessToken");
            await prefs.remove("refreshToken");
            
            // Show session expired dialog and navigate to sign in
            _showSessionExpiredDialog();
            
            return handler.next(error);
          }

          final newAccessToken = prefs.getString("accessToken");
          if (newAccessToken == null || newAccessToken.isEmpty) {
            print('❌ New access token missing after refresh');
            return handler.next(error);
          }

          try {
            // Retry original request
            final RequestOptions ro = error.requestOptions;
            final newHeaders = Map<String, dynamic>.from(ro.headers);
            newHeaders["Authorization"] = "Bearer $newAccessToken";
            final newRO = ro.copyWith(headers: newHeaders);

            print('🔁 Retrying request: ${ro.method} ${ro.path}');
            final response = await dio.fetch(newRO);
            print('✅ Retry success: ${response.statusCode}');
            return handler.resolve(response);
          } catch (e) {
            print('❌ Retry failed: $e');
            return handler.next(error);
          }
        },
      ),
    ]);
  }

  Future<bool> _refreshToken() async {
    final refreshToken = prefs.getString("refreshToken");
    print('🔄 Attempting to refresh token: $refreshToken');
    if (refreshToken == null || refreshToken.isEmpty) return false;

    try {
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: ApiUrls.baseURL,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          validateStatus: (status) => status != null && status < 500,
          contentType: Headers.jsonContentType,
        ),
      );

      // Gửi refresh token qua header, không có body
      final res = await refreshDio.post(
        ApiUrls.refreshToken,
        options: Options(headers: {"Authorization": "Bearer $refreshToken"}),
      );

      print('Refresh token response status: ${res.statusCode}');
      print('Refresh token response data: ${res.data}');

      // Chấp nhận tất cả các status code 2xx
      if (res.statusCode == null ||
          res.statusCode! < 200 ||
          res.statusCode! >= 300) {
        print('❌ Refresh token failed with status: ${res.statusCode}');
        return false;
      }

      // Chỉ nhận accessToken mới, refreshToken giữ nguyên
      final newAccessToken = res.data?["accessToken"] as String?;

      if ((newAccessToken ?? '').isNotEmpty) {
        await prefs.setString("accessToken", newAccessToken!);
        print('✅ Access token refreshed successfully');
        print('New access token: $newAccessToken');
        return true;
      }

      print('❌ Invalid token response data');
      return false;
    } catch (e) {
      print('❌ Refresh token request error: $e');
      return false;
    }
  }

  // GET
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    print('🔹 GET $url');
    return await dio.get(
      url,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  // POST
  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    print('🔹 POST $url');
    print('Body: $data');
    try {
      return await dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException {
      rethrow;
    }
  }

  // PUT
  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    print('🔹 PUT $url');
    print('Body: $data');
    try {
      return await dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException {
      rethrow;
    }
  }

  // DELETE
  Future<dynamic> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    print('🔹 DELETE $url');
    print('Body: $data');
    try {
      return await dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException {
      rethrow;
    }
  }

  // PATCH
  Future<Response> patch(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    print('🔹 PATCH $url');
    print('Body: $data');
    try {
      return await dio.patch(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException {
      rethrow;
    }
  }

  void _showSessionExpiredDialog() {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final localizations = AppLocalizations.of(context);
    if (localizations == null) return;

    showAppDialog<void>(
      context: context,
      title: localizations.sessionExpired,
      content: localizations.sessionExpiredMessage,
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.orange,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
              AppRouteConstant.signIn,
              (route) => false,
            );
          },
          child: Text(
            localizations.ok,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
