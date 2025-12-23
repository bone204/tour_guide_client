class EmailVerification {
  final String email;
  final String code;
  final String token;

  EmailVerification({
    required this.email,
    required this.code,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'code': code,
      'token': token,
    };
  }
}
