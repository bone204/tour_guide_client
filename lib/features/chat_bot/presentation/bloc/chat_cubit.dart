import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/chat_bot/data/models/chat_request.dart';
import 'package:tour_guide_app/features/chat_bot/data/models/chat_response.dart';
import 'package:tour_guide_app/features/chat_bot/data/models/chat_result_item.dart';
import 'package:tour_guide_app/features/chat_bot/presentation/bloc/chat_state.dart';
import 'package:tour_guide_app/features/chat_bot/domain/usecases/send_chat_message.dart';
import 'package:tour_guide_app/service_locator.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatState.initial());

  Future<void> sendMessage(String rawMessage, {String? lang}) async {
    final message = rawMessage.trim();
    if (message.isEmpty) return;

    final normalizedLang = (lang == 'en') ? 'en' : (lang == 'vi' ? 'vi' : null);

    final userMessage = ChatUiMessage.user(message);
    final pendingMessages = [...state.messages, userMessage];
    emit(
      state.copyWith(
        messages: pendingMessages,
        isTyping: true,
        clearError: true,
      ),
    );

    final result = await sl<SendChatMessageUseCase>().call(
      ChatRequest(message: message, lang: normalizedLang),
    );

    result.fold(
      (failure) {
        final errorText = failure.message.isNotEmpty
            ? failure.message
            : 'Đã xảy ra lỗi trong quá trình xử lý. Vui lòng thử lại.';
        final botError = ChatUiMessage.error(errorText);
        emit(
          state.copyWith(
            messages: [...pendingMessages, botError],
            isTyping: false,
            errorMessage: errorText,
          ),
        );
      },
      (response) {
        final suggestions = List<ChatResultItem>.unmodifiable(response.data);
        final fallbackText = _buildFallbackText(
          normalizedLang,
          response.source,
        );
        final rawText = response.text?.trim() ?? '';
        final content = rawText.isNotEmpty
            ? rawText
            : (suggestions.isNotEmpty
                  ? fallbackText
                  : _defaultFallback(normalizedLang));

        final botMessage = ChatUiMessage.bot(
          content,
          source: response.source,
          suggestions: suggestions,
        );

        emit(
          state.copyWith(
            messages: [...pendingMessages, botMessage],
            isTyping: false,
          ),
        );
      },
    );
  }

  void resetError() {
    emit(state.copyWith(clearError: true));
  }

  String _buildFallbackText(String? lang, ChatSource source) {
    final isEnglish = lang == 'en';
    if (source == ChatSource.database) {
      return isEnglish
          ? 'Here are some suggestions curated for you:'
          : 'Dưới đây là một vài gợi ý dành cho bạn:';
    }
    return isEnglish
        ? 'I am here to assist you with your travel plans.'
        : 'Tôi luôn sẵn sàng hỗ trợ chuyến đi của bạn.';
  }

  String _defaultFallback(String? lang) {
    final isEnglish = lang == 'en';
    return isEnglish
        ? "I'm not sure how to help with that right now, but I'm learning every day!"
        : 'Tôi chưa chắc chắn về câu hỏi này, nhưng tôi sẽ cố gắng học hỏi thêm!';
  }
}
