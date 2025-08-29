class SignInParams {
  final String identifier;
  final String password;
  final bool? rememberMe;

  SignInParams({
    required this.identifier,
    required this.password,
    this.rememberMe,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'identifier': identifier,
      'password': password,
      if (rememberMe != null) 'rememberMe': rememberMe,
    };
  }
}
