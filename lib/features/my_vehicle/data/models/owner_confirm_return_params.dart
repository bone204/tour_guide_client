import 'dart:io';

class OwnerConfirmReturnParams {
  final int id;
  final List<File> photos;
  final double latitude;
  final double longitude;
  final bool? overtimeFeeAccepted;

  OwnerConfirmReturnParams({
    required this.id,
    required this.photos,
    required this.latitude,
    required this.longitude,
    this.overtimeFeeAccepted,
  });
}
