class HotelRoomSearchRequest {
  final int? cooperationId;
  final String? provinceId;
  final String? districtId;
  final int? maxPeople;
  final int? numberOfBeds;
  final double? minPrice;
  final double? maxPrice;
  final String? status;
  final String? checkInDate;
  final String? checkOutDate;
  final int? quantity;

  HotelRoomSearchRequest({
    this.cooperationId,
    this.provinceId,
    this.districtId,
    this.maxPeople,
    this.numberOfBeds,
    this.minPrice,
    this.maxPrice,
    this.status,
    this.checkInDate,
    this.checkOutDate,
    this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      if (cooperationId != null) 'cooperationId': cooperationId,
      if (provinceId != null) 'provinceId': provinceId,
      if (districtId != null) 'districtId': districtId,
      if (maxPeople != null) 'maxPeople': maxPeople,
      if (numberOfBeds != null) 'numberOfBeds': numberOfBeds,
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
      if (status != null) 'status': status,
      if (checkInDate != null) 'checkInDate': checkInDate,
      if (checkOutDate != null) 'checkOutDate': checkOutDate,
      if (quantity != null) 'quantity': quantity,
    };
  }
}
