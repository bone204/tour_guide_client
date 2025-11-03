import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/chat_bot/data/models/chat_response.dart';
import 'package:tour_guide_app/features/chat_bot/data/models/chat_result_item.dart';

class ChatUiMessage extends Equatable {
  final String id;
  final String content;
  final bool isUser;
  final DateTime createdAt;
  final ChatSource? source;
  final List<ChatResultItem> suggestions;
  final bool isError;

  const ChatUiMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.createdAt,
    this.source,
    this.suggestions = const [],
    this.isError = false,
  });

  factory ChatUiMessage.user(String content) {
    final now = DateTime.now();
    return ChatUiMessage(
      id: 'user-${now.microsecondsSinceEpoch}',
      content: content,
      isUser: true,
      createdAt: now,
    );
  }

  factory ChatUiMessage.bot(
    String content, {
    ChatSource? source,
    List<ChatResultItem>? suggestions,
  }) {
    final now = DateTime.now();
    return ChatUiMessage(
      id: 'bot-${now.microsecondsSinceEpoch}',
      content: content,
      isUser: false,
      createdAt: now,
      source: source,
      suggestions: suggestions ?? const [],
    );
  }

  factory ChatUiMessage.error(String content) {
    final now = DateTime.now();
    return ChatUiMessage(
      id: 'error-${now.microsecondsSinceEpoch}',
      content: content,
      isUser: false,
      createdAt: now,
      isError: true,
    );
  }

  ChatUiMessage copyWith({
    String? content,
    bool? isUser,
    DateTime? createdAt,
    ChatSource? source,
    List<ChatResultItem>? suggestions,
    bool? isError,
  }) {
    return ChatUiMessage(
      id: id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      createdAt: createdAt ?? this.createdAt,
      source: source ?? this.source,
      suggestions: suggestions ?? this.suggestions,
      isError: isError ?? this.isError,
    );
  }

  bool get hasSuggestions => suggestions.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    content,
    isUser,
    createdAt,
    source,
    suggestions,
    isError,
  ];
}

class ChatState extends Equatable {
  final List<ChatUiMessage> messages;
  final bool isTyping;
  final String? errorMessage;

  const ChatState({
    required this.messages,
    this.isTyping = false,
    this.errorMessage,
  });

  factory ChatState.initial() => const ChatState(messages: []);

  ChatState copyWith({
    List<ChatUiMessage>? messages,
    bool? isTyping,
    bool clearError = false,
    String? errorMessage,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [messages, isTyping, errorMessage];
}
