class UpdateVerificationInfoModel {
  final String? email;
  final String? phone;
  final String? citizenId;
  final String? idCardImageUrl;
  final String? citizenFrontImageUrl;
  final String? citizenBackImageUrl;

  UpdateVerificationInfoModel({
    this.email,
    this.phone,
    this.citizenId,
    this.idCardImageUrl,
    this.citizenFrontImageUrl,
    this.citizenBackImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'citizenId': citizenId,
      'idCardImageUrl': idCardImageUrl,
      'citizenFrontImageUrl': citizenFrontImageUrl,
      'citizenBackImageUrl': citizenBackImageUrl,
    };
  }
}
