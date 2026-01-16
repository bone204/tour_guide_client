class CreateHotelBillRequest {
  final String checkInDate;
  final String checkOutDate;
  final List<HotelBillRoomRequest> rooms;
  final String? voucherCode;
  final int? travelPointsUsed;

  CreateHotelBillRequest({
    required this.checkInDate,
    required this.checkOutDate,
    required this.rooms,
    this.voucherCode,
    this.travelPointsUsed,
  });

  Map<String, dynamic> toJson() {
    return {
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'rooms': rooms.map((e) => e.toJson()).toList(),
      if (voucherCode != null) 'voucherCode': voucherCode,
      if (travelPointsUsed != null) 'travelPointsUsed': travelPointsUsed,
    };
  }
}

class HotelBillRoomRequest {
  final int roomId;
  final int quantity;

  HotelBillRoomRequest({required this.roomId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {'roomId': roomId, 'quantity': quantity};
  }
}
