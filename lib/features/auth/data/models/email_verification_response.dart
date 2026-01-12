import 'package:intl/intl.dart';

class EmailVerificationResponse {
  final bool ok;
  final String token;
  final DateTime expiresAt;

  EmailVerificationResponse({
    required this.ok,
    required this.token,
    required this.expiresAt,
  });

  factory EmailVerificationResponse.fromJson(Map<String, dynamic> json) {
    return EmailVerificationResponse(
      ok: json['ok'] ?? false,
      token: json['token'] ?? '',
      expiresAt: DateFormat('dd-MM-yyyy HH:mm:ss').parse(json['expiresAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {'ok': ok, 'token': token, 'expiresAt': expiresAt.toIso8601String()};
  }
}
