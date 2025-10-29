class SignUpParams {
  final String username;
  final String password;

  SignUpParams({
    required this.username,
    required this.password, 
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'username': username,
      'password': password,
    };
    return map;
  }
}
