import 'package:tour_guide_app/core/utils/string_utils.dart';

class SuggestParams {
  final String province;
  final String startDate;
  final String endDate;

  const SuggestParams({
    required this.province,
    required this.startDate,
    required this.endDate,
  });

  factory SuggestParams.fromJson(Map<String, dynamic> json) {
    return SuggestParams(
      province: json['province'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'province': removeVietnameseAccents(province),
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
