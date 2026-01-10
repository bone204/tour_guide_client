import 'dart:io';

class OwnerDeliveredParams {
  final int id;
  final List<File> photos;

  final double latitude;
  final double longitude;

  OwnerDeliveredParams({
    required this.id,
    required this.photos,
    required this.latitude,
    required this.longitude,
  });
}
