class SignInResponse {
  final String accessToken;
  final String refreshToken;

  SignInResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      accessToken: json['access_token'],
      refreshToken: json['refreshToken'],
    );
  }
}
