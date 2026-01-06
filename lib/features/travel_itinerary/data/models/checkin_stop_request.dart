class CheckInStopRequest {
  final double latitude;
  final double longitude;
  final int? toleranceMeters;

  const CheckInStopRequest({
    required this.latitude,
    required this.longitude,
    this.toleranceMeters,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
    };

    if (toleranceMeters != null) {
      json['toleranceMeters'] = toleranceMeters;
    }

    return json;
  }
}
