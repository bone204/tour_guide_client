class ContractParams {
  final int userId;
  final String? externalId;
  final String fullName;
  final String email;
  final String phone;
  final String identificationNumber;
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

  const ContractParams({
    required this.userId,
    required this.externalId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.identificationNumber,
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
  });

  factory ContractParams.fromJson(Map<String, dynamic> json) {
    return ContractParams(
      userId: json['userId'] ?? 0,
      externalId: json['externalId'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      identificationNumber: json['identificationNumber'] ?? '',
      identificationPhoto: json['identificationPhoto'],
      businessType: json['businessType'] ?? 'personal',
      businessName: json['businessName'],
      businessProvince: json['businessProvince'],
      businessCity: json['businessCity'],
      businessAddress: json['businessAddress'],
      taxCode: json['taxCode'],
      businessRegisterPhoto: json['businessRegisterPhoto'],
      citizenFrontPhoto: json['citizenFrontPhoto'],
      citizenBackPhoto: json['citizenBackPhoto'],
      contractTerm: json['contractTerm'],
      notes: json['notes'],
      bankName: json['bankName'],
      bankAccountNumber: json['bankAccountNumber'],
      bankAccountName: json['bankAccountName'],
      termsAccepted: json['termsAccepted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'externalId': externalId,
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
    };
  }

  ContractParams copyWith({
    int? userId,
    String? externalId,
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
  }) {
    return ContractParams(
      userId: userId ?? this.userId,
      externalId: externalId ?? this.externalId,
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
    );
  }
}
