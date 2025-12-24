class PhoneVerification {
  final String phone;
  final String code;
  final String sessionInfo;

  PhoneVerification({
    required this.phone,
    required this.code,
    required this.sessionInfo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phone': phone,
      'code': code,
      'sessionInfo': sessionInfo,
    };
  }
}
