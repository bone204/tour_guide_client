import 'package:equatable/equatable.dart';

class ReformProvince extends Equatable {
  final String code;
  final String name;
  final String? nameEn;
  final String fullName;
  final String? fullNameEn;
  final String? codeName;
  final String? avatarUrl;

  const ReformProvince({
    required this.code,
    required this.name,
    this.nameEn,
    required this.fullName,
    this.fullNameEn,
    this.codeName,
    this.avatarUrl,
  });

  factory ReformProvince.fromJson(Map<String, dynamic> json) {
    return ReformProvince(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      nameEn: json['name_en'],
      fullName: json['full_name'] ?? '',
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

class ReformCommune extends Equatable {
  final String code;
  final String name;
  final String? nameEn;
  final String? fullName;
  final String? fullNameEn;
  final String? codeName;
  final String? provinceCode;
  final ReformProvince? province;

  const ReformCommune({
    required this.code,
    required this.name,
    this.nameEn,
    this.fullName,
    this.fullNameEn,
    this.codeName,
    this.provinceCode,
    this.province,
  });

  factory ReformCommune.fromJson(Map<String, dynamic> json) {
    return ReformCommune(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      nameEn: json['name_en'],
      fullName: json['full_name'],
      fullNameEn: json['full_name_en'],
      codeName: json['code_name'],
      provinceCode: json['province_code'],
      province:
          json['province'] != null
              ? ReformProvince.fromJson(json['province'])
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
