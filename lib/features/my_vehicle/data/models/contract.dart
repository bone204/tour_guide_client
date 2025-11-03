class Contract {
  final int id;
  final String? externalId;
  final Map<String, dynamic>? user;  // ✅ Sửa từ List thành Map
  final int userId;
  final String fullName;
  final String? email;
  final String? phone;
  final String? identificationNumber;
  final String? identificationPhoto;
  final String businessType; // 'personal' | 'company'
  final String? businessName;
  final String? businessProvince;
  final String? businessCity;
  final String? businessAddress;
  final String? taxCode;
  final String? businessRegisterPhoto;
  final String? citizenFrontPhoto;
  final String? citizenBackPhoto;
  final String? contractTerm;
  final String? notes;
  final String? bankName;
  final String? bankAccountNumber;
  final String? bankAccountName;
  final bool termsAccepted;
  final String? status; // pending, approved, rejected...
  final String? statusReason;
  final String? statusUpdatedAt;
  final int totalVehicles;
  final int totalRentalTimes;
  final String averageRating;
  final List<dynamic>? vehicles;
  final String? createdAt;
  final String? updatedAt;

  const Contract({
    required this.id,
    this.externalId,
    this.user,
    required this.userId,
    required this.fullName,
    this.email,
    this.phone,
    this.identificationNumber,
    this.identificationPhoto,
    required this.businessType,
    this.businessName,
    this.businessProvince,
    this.businessCity,
    this.businessAddress,
    this.taxCode,
    this.businessRegisterPhoto,
    this.citizenFrontPhoto,
    this.citizenBackPhoto,
    this.contractTerm,
    this.notes,
    this.bankName,
    this.bankAccountNumber,
    this.bankAccountName,
    required this.termsAccepted,
    this.status,
    this.statusReason,
    this.statusUpdatedAt,
    required this.totalVehicles,
    required this.totalRentalTimes,
    required this.averageRating,
    this.vehicles,
    this.createdAt,
    this.updatedAt,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      id: _parseInt(json['id']) ?? 0,
      externalId: json['externalId']?.toString(),
      user: json['user'] != null && json['user'] is Map ? json['user'] as Map<String, dynamic> : null,
      userId: _parseInt(json['userId']) ?? 0,
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      identificationNumber: json['identificationNumber']?.toString(),
      identificationPhoto: json['identificationPhoto']?.toString(),
      businessType: json['businessType']?.toString() ?? 'personal',
      businessName: json['businessName']?.toString(),
      businessProvince: json['businessProvince']?.toString(),
      businessCity: json['businessCity']?.toString(),
      businessAddress: json['businessAddress']?.toString(),
      taxCode: json['taxCode']?.toString(),
      businessRegisterPhoto: json['businessRegisterPhoto']?.toString(),
      citizenFrontPhoto: json['citizenFrontPhoto']?.toString(),
      citizenBackPhoto: json['citizenBackPhoto']?.toString(),
      contractTerm: json['contractTerm']?.toString(),
      notes: json['notes']?.toString(),
      bankName: json['bankName']?.toString(),
      bankAccountNumber: json['bankAccountNumber']?.toString(),
      bankAccountName: json['bankAccountName']?.toString(),
      termsAccepted: json['termsAccepted'] == true || json['termsAccepted'] == 'true',
      status: json['status']?.toString(),
      statusReason: json['statusReason']?.toString(),
      statusUpdatedAt: json['statusUpdatedAt']?.toString(),
      totalVehicles: _parseInt(json['totalVehicles']) ?? 0,
      totalRentalTimes: _parseInt(json['totalRentalTimes']) ?? 0,
      averageRating: json['averageRating']?.toString() ?? '0.00',
      vehicles: json['vehicles'] != null && json['vehicles'] is List ? List<dynamic>.from(json['vehicles']) : null,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  // Helper method to safely parse int from dynamic value
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'externalId': externalId,
      'user': user,
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'identificationNumber': identificationNumber,
      'identificationPhoto': identificationPhoto,
      'businessType': businessType,
      'businessName': businessName,
      'businessProvince': businessProvince,
      'businessCity': businessCity,
      'businessAddress': businessAddress,
      'taxCode': taxCode,
      'businessRegisterPhoto': businessRegisterPhoto,
      'citizenFrontPhoto': citizenFrontPhoto,
      'citizenBackPhoto': citizenBackPhoto,
      'contractTerm': contractTerm,
      'notes': notes,
      'bankName': bankName,
      'bankAccountNumber': bankAccountNumber,
      'bankAccountName': bankAccountName,
      'termsAccepted': termsAccepted,
      'status': status,
      'statusReason': statusReason,
      'statusUpdatedAt': statusUpdatedAt,
      'totalVehicles': totalVehicles,
      'totalRentalTimes': totalRentalTimes,
      'averageRating': averageRating,
      'vehicles': vehicles,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Contract copyWith({
    int? id,
    String? externalId,
    Map<String, dynamic>? user,
    int? userId,
    String? fullName,
    String? email,
    String? phone,
    String? identificationNumber,
    String? identificationPhoto,
    String? businessType,
    String? businessName,
    String? businessProvince,
    String? businessCity,
    String? businessAddress,
    String? taxCode,
    String? businessRegisterPhoto,
    String? citizenFrontPhoto,
    String? citizenBackPhoto,
    String? contractTerm,
    String? notes,
    String? bankName,
    String? bankAccountNumber,
    String? bankAccountName,
    bool? termsAccepted,
    String? status,
    String? statusReason,
    String? statusUpdatedAt,
    int? totalVehicles,
    int? totalRentalTimes,
    String? averageRating,
    List<dynamic>? vehicles,
    String? createdAt,
    String? updatedAt,
  }) {
    return Contract(
      id: id ?? this.id,
      externalId: externalId ?? this.externalId,
      user: user ?? this.user,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      identificationNumber: identificationNumber ?? this.identificationNumber,
      identificationPhoto: identificationPhoto ?? this.identificationPhoto,
      businessType: businessType ?? this.businessType,
      businessName: businessName ?? this.businessName,
      businessProvince: businessProvince ?? this.businessProvince,
      businessCity: businessCity ?? this.businessCity,
      businessAddress: businessAddress ?? this.businessAddress,
      taxCode: taxCode ?? this.taxCode,
      businessRegisterPhoto: businessRegisterPhoto ?? this.businessRegisterPhoto,
      citizenFrontPhoto: citizenFrontPhoto ?? this.citizenFrontPhoto,
      citizenBackPhoto: citizenBackPhoto ?? this.citizenBackPhoto,
      contractTerm: contractTerm ?? this.contractTerm,
      notes: notes ?? this.notes,
      bankName: bankName ?? this.bankName,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      bankAccountName: bankAccountName ?? this.bankAccountName,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      status: status ?? this.status,
      statusReason: statusReason ?? this.statusReason,
      statusUpdatedAt: statusUpdatedAt ?? this.statusUpdatedAt,
      totalVehicles: totalVehicles ?? this.totalVehicles,
      totalRentalTimes: totalRentalTimes ?? this.totalRentalTimes,
      averageRating: averageRating ?? this.averageRating,
      vehicles: vehicles ?? this.vehicles,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

