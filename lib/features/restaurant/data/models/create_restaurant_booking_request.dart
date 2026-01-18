class CreateRestaurantBookingRequest {
  final List<int> tableIds;
  final String checkInDate;
  final int durationMinutes;
  final int? numberOfGuests;
  final String? notes;
  final String contactName;
  final String contactPhone;

  CreateRestaurantBookingRequest({
    required this.tableIds,
    required this.checkInDate,
    this.durationMinutes = 60,
    this.numberOfGuests,
    this.notes,
    required this.contactName,
    required this.contactPhone,
  });

  Map<String, dynamic> toJson() {
    return {
      'tableIds': tableIds,
      'checkInDate': checkInDate,
      'durationMinutes': durationMinutes,
      if (numberOfGuests != null) 'numberOfGuests': numberOfGuests,
      if (notes != null) 'notes': notes,
      'contactName': contactName,
      'contactPhone': contactPhone,
    };
  }
}
