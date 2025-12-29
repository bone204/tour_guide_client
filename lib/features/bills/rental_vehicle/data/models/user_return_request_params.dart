import 'dart:io';

class UserReturnRequestParams {
  final int id;
  final List<File> photos;
  final double latitude;
  final double longitude;

  UserReturnRequestParams({
    required this.id,
    required this.photos,
    required this.latitude,
    required this.longitude,
  });
}
