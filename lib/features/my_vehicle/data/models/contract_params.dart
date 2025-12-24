import 'package:dio/dio.dart';

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

  Future<FormData> toFormData() async {
    final map = toJson();
    // Convert boolean to string if needed, or keep as is. FormData handles basic types.
    // map['termsAccepted'] = termsAccepted.toString();

    // Handle files
    // If photos are paths (Strings) and not empty, convert to MultipartFile
    if (businessRegisterPhoto is String &&
        (businessRegisterPhoto as String).isNotEmpty &&
        !(businessRegisterPhoto as String).startsWith('http')) {
      map['businessRegisterPhoto'] = await MultipartFile.fromFile(
        businessRegisterPhoto,
      );
    } else {
      map.remove('businessRegisterPhoto');
    }

    if (citizenFrontPhoto is String &&
        (citizenFrontPhoto as String).isNotEmpty &&
        !(citizenFrontPhoto as String).startsWith('http')) {
      map['citizenFrontPhoto'] = await MultipartFile.fromFile(
        citizenFrontPhoto,
      );
    } else {
      map.remove('citizenFrontPhoto');
    }

    if (citizenBackPhoto is String &&
        (citizenBackPhoto as String).isNotEmpty &&
        !(citizenBackPhoto as String).startsWith('http')) {
      map['citizenBackPhoto'] = await MultipartFile.fromFile(citizenBackPhoto);
    } else {
      map.remove('citizenBackPhoto');
    }

    return FormData.fromMap(map);
  }
}
