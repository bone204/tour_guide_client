class ChatRequest {
  final String message;
  final String? lang;

  const ChatRequest({required this.message, this.lang});

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      if (lang != null && lang!.isNotEmpty) 'lang': lang,
    };
  }
}
