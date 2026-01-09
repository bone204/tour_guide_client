class UpdateInitialProfileModel {
  final String? fullName;
  final String? dateOfBirth;
  final String? gender;
  final String? address;
  final String? nationality;
  final String? avatarUrl;
  final String? email;
  final String? phone;
  final String? citizenId;

  UpdateInitialProfileModel({
    this.fullName,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.nationality,
    this.avatarUrl,
    this.email,
    this.phone,
    this.citizenId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'address': address,
      'nationality': nationality,
      'email': email,
      'phone': phone,
      'citizenId': citizenId,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
