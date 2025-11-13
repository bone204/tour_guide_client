import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslateService {
  static const String _baseUrl = 'https://ldfy.cc/translation/language/translate';

  /// Dịch text từ ngôn ngữ nguồn sang ngôn ngữ đích
  /// 
  /// [text] - Text cần dịch
  /// [target] - Mã ngôn ngữ đích (vi, en, zh, ko, ja)
  /// [source] - Mã ngôn ngữ nguồn (mặc định 'auto', nếu 'auto' thì sẽ dùng 'en')
  /// [apiKey] - API key để xác thực
  /// [type] - Loại engine dịch: 1=DeepL, 2=Google, 3=Baidu, 4=Youdao (mặc định '2' - Google)
  Future<String> translate({
    required String text,
    required String target,
    String source = 'auto',
    required String apiKey,
    String type = '2', // Mặc định dùng Google
  }) async {
    if (text.isEmpty) {
      return '';
    }

    if (apiKey.isEmpty) {
      throw Exception('API key is required');
    }

    try {
      final url = Uri.parse(_baseUrl);
      
      // Nếu source là 'auto', mặc định dùng 'en'
      String sourceLang = source == 'auto' ? 'en' : source;
      
      final requestBody = {
        'text': text,
        'sourceLang': sourceLang,
        'targetLang': target,
        'type': type,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(requestBody),
      );

      // Xử lý response theo format mới
      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        // Kiểm tra code trong response
        if (responseData.containsKey('code') && responseData['code'] == 200) {
          // Lấy translation từ data.translatedText
          if (responseData.containsKey('data') && 
              responseData['data'] is Map &&
              responseData['data'].containsKey('translatedText')) {
            return responseData['data']['translatedText'] ?? '';
          }
          
          throw Exception('No translation found in response');
        } else {
          // Code không phải 200
          String errorMsg = responseData['msg'] ?? 'Translation failed';
          throw Exception('Translate API error: $errorMsg');
        }
      } else {
        // Xử lý các error status codes
        String errorMessage = 'Translation failed: ${response.statusCode}';
        
        if (responseData.containsKey('msg')) {
          errorMessage = responseData['msg'];
        }
        
        // Xử lý các error codes cụ thể
        switch (response.statusCode) {
          case 401:
            throw Exception('API key không hợp lệ. Vui lòng kiểm tra API key của bạn.');
          case 402:
            throw Exception('Số dư tài khoản không đủ. Vui lòng kiểm tra số dư tài khoản.');
          case 429:
            throw Exception('Vượt quá giới hạn yêu cầu. Vui lòng liên hệ dịch vụ khách hàng.');
          default:
            throw Exception('Translate API error: $errorMessage');
        }
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Invalid response format: ${e.message}');
    } catch (e) {
      // Nếu đã là Exception với message rõ ràng thì throw lại
      if (e.toString().contains('API key') || 
          e.toString().contains('Số dư') || 
          e.toString().contains('Vượt quá') ||
          e.toString().contains('Translate API error')) {
        rethrow;
      }
      throw Exception('Translate error: ${e.toString()}');
    }
  }
}

