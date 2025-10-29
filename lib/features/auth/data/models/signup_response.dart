class SignUpResponse {
  final int id;
  final String username;

  SignUpResponse({
    required this.id,
    required this.username,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      id: json['id'],
      username: json['username'],
    );
  }
}
