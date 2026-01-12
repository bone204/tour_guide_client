import 'package:intl/intl.dart';

class PhoneVerificationResponse {
  final bool ok;
  final String sessionInfo;
  final DateTime expiresAt;

  PhoneVerificationResponse({
    required this.ok,
    required this.sessionInfo,
    required this.expiresAt,
  });

  factory PhoneVerificationResponse.fromJson(Map<String, dynamic> json) {
    return PhoneVerificationResponse(
      ok: json['ok'] ?? false,
      sessionInfo: json['sessionInfo'] ?? '',
      expiresAt: DateFormat('dd-MM-yyyy HH:mm:ss').parse(json['expiresAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ok': ok,
      'sessionInfo': sessionInfo,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }
}
