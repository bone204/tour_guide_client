import 'package:avatar_glow/avatar_glow.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/translate/translate_service.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({super.key});

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final TranslateService _translateService = TranslateService();
  bool _isListening = false;
  String _text = 'Nhấn nút và bắt đầu nói';
  String _translatedText = '';
  bool _isTranslating = false;
  String _selectedSourceLanguage = 'en'; // Mặc định tiếng Anh cho ngôn ngữ nguồn
  String _selectedLanguage = 'vi'; // Mặc định tiếng Việt cho ngôn ngữ đích
  String _lastTranslatedText = ''; // Lưu text cuối cùng đã dịch để tránh dịch lại
  
  // API Key - Cần thay bằng API key thực tế của bạn
  // Có thể lưu trong SharedPreferences hoặc config file
  final String _apiKey = '6b6238c9e4564eb6837ba1ae982d865a'; // TODO: Thêm API key

  // Danh sách ngôn ngữ
  final Map<String, String> _languages = {
    'vi': 'Tiếng Việt',
    'en': 'Tiếng Anh',
    'zh': 'Tiếng Trung',
    'ko': 'Tiếng Hàn',
    'ja': 'Tiếng Nhật',
  };

  // Map mã ngôn ngữ sang locale ID cho speech recognition
  final Map<String, String> _languageLocales = {
    'vi': 'vi_VN',
    'en': 'en_US',
    'zh': 'zh_CN',
    'ko': 'ko_KR',
    'ja': 'ja_JP',
  };

  void _clearText() {
    setState(() {
      _text = 'Nhấn nút và bắt đầu nói';
      _translatedText = '';
      _lastTranslatedText = '';
    });
  }

  Future<void> _translateText({bool force = false}) async {
    // Kiểm tra nếu text không hợp lệ
    if (_text.isEmpty || 
        _text == 'Nhấn nút và bắt đầu nói' || 
        _text.contains('Cần quyền') || 
        _text.contains('Quyền truy cập') || 
        _text.contains('Lỗi') || 
        _text.contains('Dịch vụ')) {
      setState(() {
        _translatedText = '';
        _lastTranslatedText = '';
      });
      return;
    }

    // Tránh dịch lại nếu text không thay đổi (trừ khi force = true)
    if (!force && _text == _lastTranslatedText) {
      return;
    }

    setState(() {
      _isTranslating = true;
    });

    try {
      // Kiểm tra API key
      if (_apiKey.isEmpty || _apiKey == 'YOUR_API_KEY') {
        setState(() {
          _translatedText = 'Lỗi: Chưa cấu hình API key. Vui lòng thêm API key trong code.';
          _isTranslating = false;
        });
        return;
      }

      final translated = await _translateService.translate(
        text: _text,
        target: _selectedLanguage,
        source: _selectedSourceLanguage,
        apiKey: _apiKey,
      );
      setState(() {
        _translatedText = translated;
        _lastTranslatedText = _text;
        _isTranslating = false;
      });
    } catch (e) {
      setState(() {
        // Hiển thị lỗi rõ ràng hơn
        String errorMsg = e.toString();
        if (errorMsg.contains('API key is required')) {
          _translatedText = 'Lỗi: Chưa cấu hình API key. Vui lòng thêm API key trong code.';
        } else if (errorMsg.contains('Network error')) {
          _translatedText = 'Lỗi kết nối mạng. Vui lòng kiểm tra internet.';
        } else if (errorMsg.contains('Translate API error')) {
          _translatedText = 'Lỗi API dịch: ${errorMsg.split(':').last.trim()}';
        } else if (errorMsg.contains('Invalid response')) {
          _translatedText = 'Lỗi định dạng phản hồi từ server.';
        } else {
          _translatedText = 'Lỗi dịch: ${errorMsg.replaceAll('Exception: ', '')}';
        }
        _isTranslating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Text Display Cards
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    
                    // Source Text Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryWhite,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGrey.withOpacity(0.25),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(
                                  Icons.mic_rounded,
                                  color: AppColors.primaryWhite,
                                  size: 20.sp,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  'Văn bản đã nhận diện',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge,
                                ),
                              ),
                              if (_text.isNotEmpty && 
                                  _text != 'Nhấn nút và bắt đầu nói' &&
                                  !_text.contains('Cần quyền') &&
                                  !_text.contains('Quyền truy cập') &&
                                  !_text.contains('Lỗi') &&
                                  !_text.contains('Dịch vụ'))
                                GestureDetector(
                                  onTap: _clearText,
                                  child: Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryRed.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(
                                      Icons.clear_rounded,
                                      color: AppColors.primaryRed,
                                      size: 18.sp,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          
                          // Source Language Selector
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.primaryBlue.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.language_rounded,
                                  color: AppColors.primaryBlue,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  'Ngôn ngữ nguồn:',
                                  style: Theme.of(context).textTheme.titleSmall
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedSourceLanguage,
                                      isExpanded: true,
                                      icon: Icon(
                                        Icons.arrow_drop_down_rounded,
                                        color: AppColors.primaryBlue,
                                        size: 22.sp,
                                      ),
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: AppColors.textPrimary,
                                          ),
                                      items: _languages.entries.map((entry) {
                                        return DropdownMenuItem<String>(
                                          value: entry.key,
                                          child: Text(
                                            entry.value,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: AppColors.textPrimary,
                                                ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            _selectedSourceLanguage = newValue;
                                          });
                                          _translateText();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 16.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(18.w),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: const Color.fromARGB(255, 81, 0, 255).withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              _text,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: AppColors.textPrimary,
                                    height: 1.6,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Translated Text Card with Language Selector
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryWhite,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGrey.withOpacity(0.25),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(
                                  Icons.translate_rounded,
                                  color: AppColors.primaryWhite,
                                  size: 20.sp,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  'Bản dịch',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                ),
                              ),
                              if (_isTranslating)
                                Padding(
                                  padding: EdgeInsets.only(right: 8.w),
                                  child: SizedBox(
                                    width: 18.w,
                                    height: 18.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primaryGreen,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          
                          // Language Selector - Integrated
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.primaryGreen.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.language_rounded,
                                  color: AppColors.primaryGreen,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  'Dịch sang:',
                                  style: Theme.of(context).textTheme.titleSmall
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedLanguage,
                                      isExpanded: true,
                                      icon: Icon(
                                        Icons.arrow_drop_down_rounded,
                                        color: AppColors.primaryGreen,
                                        size: 22.sp,
                                      ),
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: AppColors.textPrimary,
                                          ),
                                      items: _languages.entries.map((entry) {
                                        return DropdownMenuItem<String>(
                                          value: entry.key,
                                          child: Text(
                                            entry.value,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: AppColors.textPrimary,
                                                ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            _selectedLanguage = newValue;
                                          });
                                          _translateText();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 16.h),
                          
                          // Translated Text Content
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(18.w),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: AppColors.primaryGreen.withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: _translatedText.isEmpty
                                ? Text(
                                    _isTranslating
                                        ? 'Đang dịch...'
                                        : 'Văn bản sẽ được dịch tự động',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: AppColors.textSubtitle,
                                          fontStyle: FontStyle.italic,
                                        ),
                                  )
                                : Text(
                                    _translatedText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: AppColors.textPrimary,
                                          height: 1.6,
                                        ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),

            // Microphone Button
            Padding(
              padding: EdgeInsets.only(bottom: 32.h, top: 16.h),
              child: Column(
                children: [
                  AvatarGlow(
                    animate: _isListening,
                    glowColor: _isListening 
                        ? AppColors.primaryRed 
                        : AppColors.primaryBlue,
                    glowRadiusFactor: 0.75,
                    glowCount: 2,
                    duration: const Duration(milliseconds: 2000),
                    repeat: true,
                    child: GestureDetector(
                      onTap: _listen,
                      child: Container(
                        width: 72.w,
                        height: 72.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isListening
                              ? AppColors.primaryRed
                              : AppColors.primaryBlue,
                          boxShadow: [
                            BoxShadow(
                              color: (_isListening
                                      ? AppColors.primaryRed
                                      : AppColors.primaryBlue)
                                  .withOpacity(0.35),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                          color: AppColors.primaryWhite,
                          size: 32.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Instruction Text
                  Text(
                    _isListening
                        ? 'Đang nghe... Hãy nói rõ ràng'
                        : 'Nhấn vào nút để bắt đầu',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSubtitle,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      // Request microphone permission first
      PermissionStatus permissionStatus = await Permission.microphone.request();
      
      if (permissionStatus.isDenied) {
        setState(() {
          _text = 'Cần quyền truy cập microphone để sử dụng tính năng nhận diện giọng nói';
        });
        return;
      }
      
      if (permissionStatus.isPermanentlyDenied) {
        setState(() {
          _text = 'Quyền truy cập microphone đã bị từ chối vĩnh viễn. Vui lòng bật trong cài đặt.';
        });
        return;
      }

      bool available = await _speech.initialize(
        onStatus: (val) {
          print('onStatus: $val');
          if (val == 'done' || val == 'notListening') {
            setState(() => _isListening = false);
            // Dịch lại khi dừng nghe để đảm bảo có bản dịch cuối cùng
            _translateText(force: true);
          }
        },
        onError: (val) {
          print('onError: $val');
          setState(() {
            _isListening = false;
            // Handle different error types with user-friendly messages
            if (val.errorMsg.contains('error_no_match') || 
                val.errorMsg.contains('no_match')) {
              _text = 'Không phát hiện giọng nói. Vui lòng thử nói lại.';
            } else if (val.errorMsg.contains('error_audio') ||
                       val.errorMsg.contains('audio')) {
              _text = 'Lỗi âm thanh. Vui lòng kiểm tra microphone của bạn.';
            } else if (val.errorMsg.contains('error_network')) {
              _text = 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet.';
            } else if (val.errorMsg.contains('error_server')) {
              _text = 'Lỗi máy chủ. Vui lòng thử lại sau.';
            } else {
              _text = 'Lỗi: ${val.errorMsg}';
            }
          });
        },
      );
      
      if (available) {
        setState(() => _isListening = true);
        // Lấy locale ID cho ngôn ngữ nguồn đã chọn
        String localeId = _languageLocales[_selectedSourceLanguage] ?? 'en_US';
        
        _speech.listen(
          onResult: (val) {
            if (val.recognizedWords.isNotEmpty) {
              setState(() {
            _text = val.recognizedWords;
              });
              // Với partial results, chỉ cập nhật text
              // Sẽ dịch tự động khi dừng nghe (trong onStatus)
            }
          },
          localeId: localeId,
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 3),
          cancelOnError: false,
          partialResults: true,
        );
      } else {
        setState(() {
          _text = 'Dịch vụ nhận diện giọng nói không khả dụng. Vui lòng kiểm tra cài đặt hệ thống.';
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}