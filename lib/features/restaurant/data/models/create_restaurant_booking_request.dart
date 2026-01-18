class CreateRestaurantBookingRequest {
  final int tableId;
  final String checkInDate;
  final int durationMinutes;
  final int? numberOfGuests;
  final String? notes;
  final String contactName;
  final String contactPhone;
  final int quantity;
  final List<Map<String, dynamic>>? items;

  CreateRestaurantBookingRequest({
    required this.tableId,
    required this.checkInDate,
    this.durationMinutes = 60,
    this.numberOfGuests,
    this.notes,
    required this.contactName,
    required this.contactPhone,
    this.quantity = 1,
    this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'tableId': tableId,
      'checkInDate': checkInDate,
      'durationMinutes': durationMinutes,
      if (numberOfGuests != null) 'numberOfGuests': numberOfGuests,
      if (notes != null) 'notes': notes,
      'contactName': contactName,
      'contactPhone': contactPhone,
      // 'quantity': quantity, // Removed as backend DTO does not allow it at root when using items or forbids it completely
      if (items != null) 'items': items,
    };
  }
}
