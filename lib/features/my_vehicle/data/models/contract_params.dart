import 'package:dio/dio.dart';

class ContractParams {
  final String fullName;
  final String email;
  final String phoneNumber;

  final String citizenId;
  final String businessType;
  final String businessName;
  final String businessAddress;
  final String taxCode;

  final double? businessLatitude;
  final double? businessLongitude;

  /// File upload (multipart)
  final dynamic businessRegisterPhoto;
  final dynamic citizenFrontPhoto;

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
    this.businessAddress = '',
    this.taxCode = '',
    this.businessLatitude,
    this.businessLongitude,
    this.businessRegisterPhoto,
    this.citizenFrontPhoto,

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
      'businessAddress': businessAddress,
      'taxCode': taxCode,
      'businessLatitude': businessLatitude,
      'businessLongitude': businessLongitude,
      'businessRegisterPhoto': businessRegisterPhoto,
      'citizenFrontPhoto': citizenFrontPhoto,
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

    return FormData.fromMap(map);
  }
}
