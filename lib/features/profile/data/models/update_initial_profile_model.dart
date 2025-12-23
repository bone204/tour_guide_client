class UpdateInitialProfileModel {
  final String? fullName;
  final String? dateOfBirth;
  final String? gender;
  final String? address;
  final String? nationality;
  final String? avatarUrl;

  UpdateInitialProfileModel({
    this.fullName,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.nationality,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'address': address,
      'nationality': nationality,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
