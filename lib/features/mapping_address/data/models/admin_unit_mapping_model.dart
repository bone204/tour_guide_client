class AdminUnitMapping {
  final int id;
  final String oldProvinceCode;
  final String? oldDistrictCode;
  final String? oldWardCode;
  final String newProvinceCode;
  final String? newCommuneCode;
  final String? note;
  final String? resolutionRef;
  final String createdAt;
  final String updatedAt;

  AdminUnitMapping({
    required this.id,
    required this.oldProvinceCode,
    this.oldDistrictCode,
    this.oldWardCode,
    required this.newProvinceCode,
    this.newCommuneCode,
    this.note,
    this.resolutionRef,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminUnitMapping.fromJson(Map<String, dynamic> json) {
    return AdminUnitMapping(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      oldProvinceCode: json['old_province_code'] ?? '',
      oldDistrictCode: json['old_district_code'],
      oldWardCode: json['old_ward_code'],
      newProvinceCode: json['new_province_code'] ?? '',
      newCommuneCode: json['new_commune_code'],
      note: json['note'],
      resolutionRef: json['resolution_ref'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
