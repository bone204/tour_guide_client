import 'package:equatable/equatable.dart';

class LegacyProvince extends Equatable {
  final String code;
  final String name;
  final String? nameEn;
  final String? fullName;
  final String? fullNameEn;
  final String? codeName;
  final String? avatarUrl;

  const LegacyProvince({
    required this.code,
    required this.name,
    this.nameEn,
    this.fullName,
    this.fullNameEn,
    this.codeName,
    this.avatarUrl,
  });

  factory LegacyProvince.fromJson(Map<String, dynamic> json) {
    return LegacyProvince(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      nameEn: json['name_en'],
      fullName: json['full_name'],
      fullNameEn: json['full_name_en'],
      codeName: json['code_name'],
      avatarUrl: json['avatar_url'],
    );
  }

  @override
  List<Object?> get props => [
    code,
    name,
    nameEn,
    fullName,
    fullNameEn,
    codeName,
    avatarUrl,
  ];
}

class LegacyDistrict extends Equatable {
  final String code;
  final String name;
  final String? nameEn;
  final String? fullName;
  final String? fullNameEn;
  final String? codeName;
  final String? provinceCode;
  final LegacyProvince? province;

  const LegacyDistrict({
    required this.code,
    required this.name,
    this.nameEn,
    this.fullName,
    this.fullNameEn,
    this.codeName,
    this.provinceCode,
    this.province,
  });

  factory LegacyDistrict.fromJson(Map<String, dynamic> json) {
    return LegacyDistrict(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      nameEn: json['name_en'],
      fullName: json['full_name'],
      fullNameEn: json['full_name_en'],
      codeName: json['code_name'],
      provinceCode: json['province_code'],
      province:
          json['province'] != null
              ? LegacyProvince.fromJson(json['province'])
              : null,
    );
  }

  @override
  List<Object?> get props => [
    code,
    name,
    nameEn,
    fullName,
    fullNameEn,
    codeName,
    provinceCode,
    province,
  ];
}

class LegacyWard extends Equatable {
  final String code;
  final String name;
  final String? nameEn;
  final String? fullName;
  final String? fullNameEn;
  final String? codeName;
  final String? districtCode;
  final LegacyDistrict? district;

  const LegacyWard({
    required this.code,
    required this.name,
    this.nameEn,
    this.fullName,
    this.fullNameEn,
    this.codeName,
    this.districtCode,
    this.district,
  });

  factory LegacyWard.fromJson(Map<String, dynamic> json) {
    return LegacyWard(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      nameEn: json['name_en'],
      fullName: json['full_name'],
      fullNameEn: json['full_name_en'],
      codeName: json['code_name'],
      districtCode: json['district_code'],
      district:
          json['district'] != null
              ? LegacyDistrict.fromJson(json['district'])
              : null,
    );
  }

  @override
  List<Object?> get props => [
    code,
    name,
    nameEn,
    fullName,
    fullNameEn,
    codeName,
    districtCode,
    district,
  ];
}
