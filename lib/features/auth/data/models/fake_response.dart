class FakeResponse {
  final String identifier;
  final String password;
  final String id;
  final String refreshToken;
  final String accessToken;

  FakeResponse({
    required this.identifier,
    required this.password,
    required this.id,
    required this.accessToken,
    required this.refreshToken,
  });

  factory FakeResponse.fromJson(Map<String, dynamic> json) {
    return FakeResponse(
      identifier: json['identifier'],
      password: json['password'],
      id: json['id'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken']
    );
  }
}
