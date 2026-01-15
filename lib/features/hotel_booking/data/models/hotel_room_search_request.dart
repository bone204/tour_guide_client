class HotelRoomSearchRequest {
  final double? latitude;
  final double? longitude;
  final String? checkInDate;
  final String? checkOutDate;
  final int? guests;
  final double? minPrice;
  final double? maxPrice;

  HotelRoomSearchRequest({
    this.latitude,
    this.longitude,
    this.checkInDate,
    this.checkOutDate,
    this.guests,
    this.minPrice,
    this.maxPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (checkInDate != null) 'checkInDate': checkInDate,
      if (checkOutDate != null) 'checkOutDate': checkOutDate,
      if (guests != null) 'guests': guests,
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
    };
  }
}
