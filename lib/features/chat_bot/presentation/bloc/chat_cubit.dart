import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tour_guide_app/features/chat_bot/data/models/chat_request.dart';
import 'package:tour_guide_app/features/chat_bot/data/models/chat_response.dart';
import 'package:tour_guide_app/features/chat_bot/data/models/chat_result_item.dart';
import 'package:tour_guide_app/features/chat_bot/domain/usecases/send_chat_message.dart';
import 'package:tour_guide_app/features/chat_bot/presentation/bloc/chat_state.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:uuid/uuid.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatState.initial()) {
    _initSession();
  }

  void _initSession() {
    emit(state.copyWith(sessionId: const Uuid().v4()));
  }

  Future<void> pickImages() async {
    if (state.selectedImages.length >= 3) return;

    final picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(
      limit: 3 - state.selectedImages.length,
    );

    if (isClosed) return;

    if (images.isNotEmpty) {
      final currentList = List<String>.from(state.selectedImages);
      final availableSlots = 3 - currentList.length;
      final newImages = images.take(availableSlots).map((e) => e.path).toList();

      emit(state.copyWith(selectedImages: [...currentList, ...newImages]));
    }
  }

  void removeImage(String path) {
    final newImages = List<String>.from(state.selectedImages)..remove(path);
    emit(state.copyWith(selectedImages: newImages));
  }

  Future<void> sendMessage(String rawMessage, {String? lang}) async {
    final message = rawMessage.trim();
    final imagesToSend = List<String>.from(state.selectedImages);

    // Allow sending if there are images, even if message is empty (optional, but good UX)
    // But server might require message to be not empty?
    // Server check: `if (!message) throw BadRequestException('Message must not be empty');`
    // So message is required.
    if (message.isEmpty && imagesToSend.isEmpty) return;

    // Use a placeholder message if user only sends image?
    // "Gửi ảnh" or similar if empty? User provided logic usually prevents empty send.
    // Let's assume user must type something or we send a generic text if empty but has image.
    final messageToSend =
        message.isEmpty ? 'Phân tích ảnh này giúp tôi' : message;

    final normalizedLang = (lang == 'en') ? 'en' : (lang == 'vi' ? 'vi' : null);

    final userMessage = ChatUiMessage.user(messageToSend, images: imagesToSend);
    final pendingMessages = [...state.messages, userMessage];

    emit(
      state.copyWith(
        messages: pendingMessages,
        isTyping: true,
        clearError: true,
        selectedImages: [], // Clear selected images immediately
      ),
    );

    final result = await sl<SendChatMessageUseCase>().call(
      ChatRequest(
        message: messageToSend,
        lang: normalizedLang,
        sessionId: state.sessionId,
        images: imagesToSend,
      ),
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        final errorText =
            failure.message.isNotEmpty
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
        final content =
            rawText.isNotEmpty
                ? rawText
                : (suggestions.isNotEmpty
                    ? fallbackText
                    : _defaultFallback(normalizedLang));

        // Handle images from response? Server response might have images (e.g. from user input echo or found images)
        // Response has `images` field (List<ChatImagePayload> in server, mapped to what?
        // We didn't update ChatResponse to parse `images` yet.
        // But for now, user images are shown via `userMessage`. Bot images are usually in `suggestions`.
        // If bot sends independent images (e.g. generated), we might need to handle it.
        // Server `ChatResponse` has `images`. Client `ChatResponse` doesn't map it top-level yet only in items?
        // Wait, server response has top level `images` field.
        // Client `ChatResponse` uses `ChatResultItem` list `data`.
        // Let's check `ChatResponse` again. It has `data`, `text`. No `images`.
        // I won't update Client `ChatResponse` for top-level images for now unless requested.
        // The server puts found images in `data` items usually.

        final responseImages =
            response.images
                ?.map((img) => img.url ?? '')
                .where((url) => url.isNotEmpty)
                .toList() ??
            [];

        final botMessage = ChatUiMessage.bot(
          content,
          source: response.source,
          suggestions: suggestions,
          images: responseImages,
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
