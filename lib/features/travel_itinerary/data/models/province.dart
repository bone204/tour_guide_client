class Province {
  final String code;
  final String name;
  final String? nameEn;
  final String? fullName;
  final String? fullNameEn;
  final String? codeName;
  final int? administrativeUnitId;
  final String? avatarUrl;
  final int? administrativeRegionId;
  final AdministrativeUnit? administrativeUnit;
  final AdministrativeRegion? region;
  final List<District>? districts;

  Province({
    required this.code,
    required this.name,
    this.nameEn,
    this.fullName,
    this.fullNameEn,
    this.codeName,
    this.administrativeUnitId,
    this.avatarUrl,
    this.administrativeRegionId,
    this.administrativeUnit,
    this.region,
    this.districts,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      nameEn: json['nameEn'],
      fullName: json['fullName'],
      fullNameEn: json['fullNameEn'],
      codeName: json['codeName'],
      administrativeUnitId: json['administrativeUnitId'],
      avatarUrl: json['avatarUrl'],
      administrativeRegionId: json['administrativeRegionId'],
      administrativeUnit:
          json['administrativeUnit'] != null
              ? AdministrativeUnit.fromJson(json['administrativeUnit'])
              : null,
      region:
          json['region'] != null
              ? AdministrativeRegion.fromJson(json['region'])
              : null,
      districts:
          json['districts'] != null
              ? (json['districts'] as List)
                  .map((e) => District.fromJson(e))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'nameEn': nameEn,
      'fullName': fullName,
      'fullNameEn': fullNameEn,
      'codeName': codeName,
      'administrativeUnitId': administrativeUnitId,
      'avatarUrl': avatarUrl,
      'administrativeRegionId': administrativeRegionId,
      'administrativeUnit': administrativeUnit?.toJson(),
      'region': region?.toJson(),
      'districts': districts?.map((e) => e.toJson()).toList(),
    };
  }
}

class AdministrativeUnit {
  final int id;
  final String? fullName;
  final String? fullNameEn;
  final String? shortName;
  final String? shortNameEn;
  final String? codeName;
  final String? codeNameEn;

  AdministrativeUnit({
    required this.id,
    this.fullName,
    this.fullNameEn,
    this.shortName,
    this.shortNameEn,
    this.codeName,
    this.codeNameEn,
  });

  factory AdministrativeUnit.fromJson(Map<String, dynamic> json) {
    return AdministrativeUnit(
      id: json['id'],
      fullName: json['fullName'],
      fullNameEn: json['fullNameEn'],
      shortName: json['shortName'],
      shortNameEn: json['shortNameEn'],
      codeName: json['codeName'],
      codeNameEn: json['codeNameEn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'fullNameEn': fullNameEn,
      'shortName': shortName,
      'shortNameEn': shortNameEn,
      'codeName': codeName,
      'codeNameEn': codeNameEn,
    };
  }
}

class AdministrativeRegion {
  final int id;
  final String name;
  final String? nameEn;
  final String? codeName;
  final String? codeNameEn;

  AdministrativeRegion({
    required this.id,
    required this.name,
    this.nameEn,
    this.codeName,
    this.codeNameEn,
  });

  factory AdministrativeRegion.fromJson(Map<String, dynamic> json) {
    return AdministrativeRegion(
      id: json['id'],
      name: json['name'],
      nameEn: json['nameEn'],
      codeName: json['codeName'],
      codeNameEn: json['codeNameEn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameEn': nameEn,
      'codeName': codeName,
      'codeNameEn': codeNameEn,
    };
  }
}

class District {
  final String code;
  final String name;
  final String? nameEn;
  final String? fullName;
  final String? fullNameEn;
  final String? codeName;
  final String? provinceCode;
  final int? administrativeUnitId;
  final AdministrativeUnit? administrativeUnit;
  final List<Ward>? wards;

  District({
    required this.code,
    required this.name,
    this.nameEn,
    this.fullName,
    this.fullNameEn,
    this.codeName,
    this.provinceCode,
    this.administrativeUnitId,
    this.administrativeUnit,
    this.wards,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      nameEn: json['nameEn'],
      fullName: json['fullName'],
      fullNameEn: json['fullNameEn'],
      codeName: json['codeName'],
      provinceCode: json['provinceCode'],
      administrativeUnitId: json['administrativeUnitId'],
      administrativeUnit:
          json['administrativeUnit'] != null
              ? AdministrativeUnit.fromJson(json['administrativeUnit'])
              : null,
      wards:
          json['wards'] != null
              ? (json['wards'] as List).map((e) => Ward.fromJson(e)).toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'nameEn': nameEn,
      'fullName': fullName,
      'fullNameEn': fullNameEn,
      'codeName': codeName,
      'provinceCode': provinceCode,
      'administrativeUnitId': administrativeUnitId,
      'administrativeUnit': administrativeUnit?.toJson(),
      'wards': wards?.map((e) => e.toJson()).toList(),
    };
  }
}

class Ward {
  final String code;
  final String name;
  final String? nameEn;
  final String? fullName;
  final String? fullNameEn;
  final String? codeName;
  final String? districtCode;
  final int? administrativeUnitId;
  final AdministrativeUnit? administrativeUnit;

  Ward({
    required this.code,
    required this.name,
    this.nameEn,
    this.fullName,
    this.fullNameEn,
    this.codeName,
    this.districtCode,
    this.administrativeUnitId,
    this.administrativeUnit,
  });

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      nameEn: json['nameEn'],
      fullName: json['fullName'],
      fullNameEn: json['fullNameEn'],
      codeName: json['codeName'],
      districtCode: json['districtCode'],
      administrativeUnitId: json['administrativeUnitId'],
      administrativeUnit:
          json['administrativeUnit'] != null
              ? AdministrativeUnit.fromJson(json['administrativeUnit'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'nameEn': nameEn,
      'fullName': fullName,
      'fullNameEn': fullNameEn,
      'codeName': codeName,
      'districtCode': districtCode,
      'administrativeUnitId': administrativeUnitId,
      'administrativeUnit': administrativeUnit?.toJson(),
    };
  }
}

class ProvinceResponse {
  final List<Province> items;

  ProvinceResponse({required this.items});

  factory ProvinceResponse.fromJson(dynamic json) {
    if (json is List) {
      return ProvinceResponse(
        items:
            json
                .map((e) => Province.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
    } else if (json is Map<String, dynamic>) {
      return ProvinceResponse(
        items:
            (json['items'] as List<dynamic>? ?? [])
                .map((e) => Province.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
    } else {
      return ProvinceResponse(items: []);
    }
  }

  Map<String, dynamic> toJson() {
    return {'items': items.map((e) => e.toJson()).toList()};
  }
}
