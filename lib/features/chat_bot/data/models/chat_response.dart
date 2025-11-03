import 'package:tour_guide_app/features/chat_bot/data/models/chat_result_item.dart';

enum ChatSource { database, ai, unknown }

extension ChatSourceX on ChatSource {
  static ChatSource fromValue(String? value) {
    switch (value) {
      case 'database':
        return ChatSource.database;
      case 'ai':
        return ChatSource.ai;
      default:
        return ChatSource.unknown;
    }
  }

  String get value {
    switch (this) {
      case ChatSource.database:
        return 'database';
      case ChatSource.ai:
        return 'ai';
      case ChatSource.unknown:
        return 'unknown';
    }
  }
}

class ChatResponse {
  final ChatSource source;
  final String? text;
  final List<ChatResultItem> data;

  const ChatResponse({required this.source, required this.data, this.text});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final items = rawData is List
        ? rawData
              .whereType<Map<String, dynamic>>()
              .map(ChatResultItem.fromJson)
              .toList()
        : <ChatResultItem>[];

    return ChatResponse(
      source: ChatSourceX.fromValue(json['source'] as String?),
      text: json['text'] as String?,
      data: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source.value,
      'text': text,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }

  bool get hasData => data.isNotEmpty;

  ChatResultItem? get primaryItem => data.isEmpty ? null : data.first;
}
