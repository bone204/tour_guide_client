class ContractParams {
  final String fullName;
  final String email;
  final String phoneNumber;

  final String citizenId;
  final String businessType;
  final String businessName;
  final String businessProvince;
  final String businessAddress;
  final String taxCode;

  /// File upload (multipart)
  final dynamic businessRegisterPhoto;
  final dynamic citizenFrontPhoto;
  final dynamic citizenBackPhoto;

  final String notes;

  final String bankName;
  final String bankAccountNumber;
  final String bankAccountName;

  final bool termsAccepted;

  ContractParams({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.citizenId,
    required this.businessType,
    this.businessName = '',
    this.businessProvince = '',
    this.businessAddress = '',
    this.taxCode = '',
    this.businessRegisterPhoto,
    this.citizenFrontPhoto,
    this.citizenBackPhoto,
    this.notes = '',
    required this.bankName,
    required this.bankAccountNumber,
    required this.bankAccountName,
    required this.termsAccepted,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'citizenId': citizenId,
      'businessType': businessType,
      'businessName': businessName,
      'businessProvince': businessProvince,
      'businessAddress': businessAddress,
      'taxCode': taxCode,
      'businessRegisterPhoto': businessRegisterPhoto,
      'citizenFrontPhoto': citizenFrontPhoto,
      'citizenBackPhoto': citizenBackPhoto,
      'notes': notes,
      'bankName': bankName,
      'bankAccountNumber': bankAccountNumber,
      'bankAccountName': bankAccountName,
      'termsAccepted': termsAccepted,
    };
  }
}
