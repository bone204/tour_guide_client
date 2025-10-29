class SuccessResponse {
  final String message;

  SuccessResponse({required this.message});

  factory SuccessResponse.fromJson(dynamic json) {
    if (json is bool) {
      return SuccessResponse(
        message: json ? "Thành công" : "Thất bại",
      );
    } else if (json is String) {
      return SuccessResponse(message: json.isNotEmpty ? json : "Thành công");
    } else if (json is Map<String, dynamic>) {
      return SuccessResponse(
        message: json['message']?.toString() ?? "Thành công",
      );
    } else {
      return SuccessResponse(message: "Thành công");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
