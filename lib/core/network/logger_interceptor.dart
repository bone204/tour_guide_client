import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// This interceptor is used to show request and response logs
class LoggerInterceptor extends Interceptor {
  final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 0,
      lineLength: 90,
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestPath = '${options.baseUrl}${options.path}';
    logger.i('''
➡️ ${options.method} $requestPath
Headers: ${options.headers}
Query: ${options.queryParameters}
Data: ${_formatRequestData(options.data)}
''');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d('''
✅ ${response.requestOptions.method} ${response.requestOptions.uri}
Status: ${response.statusCode} ${response.statusMessage}
Headers: ${response.headers}
Data: ${_prettyJson(response.data)}
''');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    logger.e('''
❌ ${options.method} ${options.uri}
Error: ${err.error}
Message: ${err.message}
Status Code: ${err.response?.statusCode}
Response: ${_prettyJson(err.response?.data)}
''');
    handler.next(err);
  }

  String _prettyJson(dynamic data) {
    if (data == null) return 'No data';

    try {
      if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ').convert(data);
      }

      if (data is String) {
        final parsed = json.decode(data);
        return const JsonEncoder.withIndent('  ').convert(parsed);
      }
    } catch (_) {
      // ignore parsing errors and fall back to raw string below
    }

    return _truncateIfNeeded(data);
  }

  String _truncateIfNeeded(dynamic data, {int maxLength = 400}) {
    if (data == null) return 'null';
    final str = data.toString();
    if (str.length <= maxLength) return str;
    return '${str.substring(0, maxLength)}... (truncated)';
  }

  String _formatRequestData(dynamic data) {
    if (data == null) return 'null';

    if (data is FormData) {
      final buffer = StringBuffer();
      buffer.writeln('FormData fields:');
      for (final field in data.fields) {
        buffer.writeln('  • ${field.key}: ${field.value}');
      }
      buffer.writeln('FormData files:');
      for (final file in data.files) {
        buffer.writeln(
          '  • ${file.key}: filename=${file.value.filename}, '
          'length=${file.value.length}, contentType=${file.value.contentType}',
        );
      }
      return buffer.toString();
    }

    return _truncateIfNeeded(data);
  }
}
