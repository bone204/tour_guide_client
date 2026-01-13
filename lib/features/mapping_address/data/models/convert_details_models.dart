import 'legacy_location_models.dart';
import 'reform_location_models.dart';

class ConvertOldToNewDetailsDto {
  final String province;
  final String? district;
  final String? ward;

  ConvertOldToNewDetailsDto({required this.province, this.district, this.ward});

  Map<String, dynamic> toJson() {
    return {'province': province, 'district': district, 'ward': ward};
  }
}

class ConvertOldToNewDetailsResponse {
  final ReformProvince province;
  final ReformCommune commune;

  ConvertOldToNewDetailsResponse({
    required this.province,
    required this.commune,
  });

  factory ConvertOldToNewDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ConvertOldToNewDetailsResponse(
      province: ReformProvince.fromJson(json['province'] ?? {}),
      commune: ReformCommune.fromJson(json['commune'] ?? {}),
    );
  }
}

class ConvertNewToOldDetailsDto {
  final String province;
  final String? commune;

  ConvertNewToOldDetailsDto({required this.province, this.commune});

  Map<String, dynamic> toJson() {
    return {'province': province, 'commune': commune};
  }
}

class ConvertNewToOldDetailsItem {
  final LegacyProvince? province;
  final LegacyDistrict? district;
  final LegacyWard? ward;

  ConvertNewToOldDetailsItem({this.province, this.district, this.ward});

  factory ConvertNewToOldDetailsItem.fromJson(Map<String, dynamic> json) {
    return ConvertNewToOldDetailsItem(
      province:
          json['province'] != null
              ? LegacyProvince.fromJson(json['province'])
              : null,
      district:
          json['district'] != null
              ? LegacyDistrict.fromJson(json['district'])
              : null,
      ward: json['ward'] != null ? LegacyWard.fromJson(json['ward']) : null,
    );
  }
}
