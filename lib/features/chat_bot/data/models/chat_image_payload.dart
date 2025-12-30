class ChatImagePayload {
  final String source;
  final String? url;
  final String? base64;
  final String? mimeType;
  final String? caption;

  const ChatImagePayload({
    required this.source,
    this.url,
    this.base64,
    this.mimeType,
    this.caption,
  });

  factory ChatImagePayload.fromJson(Map<String, dynamic> json) {
    return ChatImagePayload(
      source: json['source'] ?? 'unknown',
      url: json['url'] as String?,
      base64: json['base64'] as String?,
      mimeType: json['mimeType'] as String?,
      caption: json['caption'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'url': url,
      'base64': base64,
      'mimeType': mimeType,
      'caption': caption,
    };
  }
}
