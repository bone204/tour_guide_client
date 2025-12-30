import 'package:tour_guide_app/features/chat_bot/data/models/chat_image_payload.dart';
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
  final List<ChatImagePayload>? images;

  const ChatResponse({
    required this.source,
    required this.data,
    this.text,
    this.images,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final items =
        rawData is List
            ? rawData
                .whereType<Map<String, dynamic>>()
                .map(ChatResultItem.fromJson)
                .toList()
            : <ChatResultItem>[];

    final rawImages = json['images'];
    final imagePayloads =
        rawImages is List
            ? rawImages
                .whereType<Map<String, dynamic>>()
                .map(ChatImagePayload.fromJson)
                .toList()
            : <ChatImagePayload>[];

    String? textContent;
    final rawText = json['text'];
    if (rawText is String) {
      textContent = rawText;
    } else if (rawText is Map) {
      final opening = rawText['opening'] as String?;
      final closing = rawText['closing'] as String?;
      final parts = [opening, closing].where((e) => e != null && e.isNotEmpty);
      if (parts.isNotEmpty) {
        textContent = parts.join('\n\n');
      }
    }

    return ChatResponse(
      source: ChatSourceX.fromValue(json['source'] as String?),
      text: textContent,
      data: items,
      images: imagePayloads,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source.value,
      'text': text,
      'data': data.map((item) => item.toJson()).toList(),
      'images': images?.map((img) => img.toJson()).toList(),
    };
  }

  bool get hasData => data.isNotEmpty;

  ChatResultItem? get primaryItem => data.isEmpty ? null : data.first;
}
