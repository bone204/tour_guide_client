enum BusinessType {
  personal,
  company;

  String get value => name;

  static BusinessType fromString(String? value) {
    if (value == null) return BusinessType.personal;
    return BusinessType.values.firstWhere(
      (type) => type.value == value.toLowerCase(),
      orElse: () => BusinessType.personal,
    );
  }
}

class ContractParams {
  final String? citizenId;
  final BusinessType businessType;
  final String? businessName;
  final String? businessProvince;
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
    this.citizenId,
    this.businessType = BusinessType.personal,
    this.businessName,
    this.businessProvince,
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
      citizenId: json['citizenId'] as String?,
      businessType: BusinessType.fromString(json['businessType'] as String?),
      businessName: json['businessName'] as String?,
      businessProvince: json['businessProvince'] as String?,
      businessAddress: json['businessAddress'] as String?,
      taxCode: json['taxCode'] as String?,
      businessRegisterPhoto: json['businessRegisterPhoto'] as String?,
      citizenFrontPhoto: json['citizenFrontPhoto'] as String?,
      citizenBackPhoto: json['citizenBackPhoto'] as String?,
      contractTerm: json['contractTerm'] as String?,
      notes: json['notes'] as String?,
      bankName: json['bankName'] as String?,
      bankAccountNumber: json['bankAccountNumber'] as String?,
      bankAccountName: json['bankAccountName'] as String?,
      termsAccepted: json['termsAccepted'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'citizenId': citizenId,
      'businessType': businessType.value,
      'businessName': businessName,
      'businessProvince': businessProvince,
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
    String? citizenId,
    BusinessType? businessType,
    String? businessName,
    String? businessProvince,
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
      citizenId: citizenId ?? this.citizenId,
      businessType: businessType ?? this.businessType,
      businessName: businessName ?? this.businessName,
      businessProvince: businessProvince ?? this.businessProvince,
      businessAddress: businessAddress ?? this.businessAddress,
      taxCode: taxCode ?? this.taxCode,
      businessRegisterPhoto:
          businessRegisterPhoto ?? this.businessRegisterPhoto,
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
