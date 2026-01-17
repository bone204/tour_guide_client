class RestaurantTableSearchRequest {
  final double? latitude;
  final double? longitude;
  final String? reservationTime;
  final int? guests;
  final String? dishType;

  RestaurantTableSearchRequest({
    this.latitude,
    this.longitude,
    this.reservationTime,
    this.guests,
    this.dishType,
  });

  Map<String, dynamic> toJson() {
    return {
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (reservationTime != null) 'reservationTime': reservationTime,
      if (guests != null) 'guests': guests,
      if (dishType != null) 'dishType': dishType,
    };
  }
}
