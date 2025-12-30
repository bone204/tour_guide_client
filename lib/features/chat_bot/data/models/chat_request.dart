class ChatRequest {
  final String message;
  final String? lang;
  final String? sessionId;
  final List<String> images;

  const ChatRequest({
    required this.message,
    this.lang,
    this.sessionId,
    this.images = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      if (lang != null && lang!.isNotEmpty) 'lang': lang,
      if (sessionId != null) 'sessionId': sessionId,
      if (images.isNotEmpty) 'images': images,
    };
  }
}
