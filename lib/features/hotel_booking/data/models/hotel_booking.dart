import 'package:tour_guide_app/features/hotel_booking/data/models/room.dart';

class RoomBooking {
  final HotelRoom room;
  final int quantity;

  RoomBooking({required this.room, required this.quantity});

  double get totalPrice => room.price * quantity;
}

class HotelBooking {
  final String? hotelName;
  final String? hotelAddress;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int? numberOfNights;
  final List<RoomBooking> selectedRooms;
  final String? guestName;
  final String? guestPhone;
  final String? guestEmail;
  final String? specialRequests;
  final double totalCost;

  HotelBooking({
    this.hotelName,
    this.hotelAddress,
    this.checkInDate,
    this.checkOutDate,
    this.numberOfNights,
    this.selectedRooms = const [],
    this.guestName,
    this.guestPhone,
    this.guestEmail,
    this.specialRequests,
    this.totalCost = 0,
  });

  HotelBooking copyWith({
    String? hotelName,
    String? hotelAddress,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? numberOfNights,
    List<RoomBooking>? selectedRooms,
    String? guestName,
    String? guestPhone,
    String? guestEmail,
    String? specialRequests,
    double? totalCost,
  }) {
    return HotelBooking(
      hotelName: hotelName ?? this.hotelName,
      hotelAddress: hotelAddress ?? this.hotelAddress,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      numberOfNights: numberOfNights ?? this.numberOfNights,
      selectedRooms: selectedRooms ?? this.selectedRooms,
      guestName: guestName ?? this.guestName,
      guestPhone: guestPhone ?? this.guestPhone,
      guestEmail: guestEmail ?? this.guestEmail,
      specialRequests: specialRequests ?? this.specialRequests,
      totalCost: totalCost ?? this.totalCost,
    );
  }

  int get totalRooms =>
      selectedRooms.fold(0, (sum, booking) => sum + booking.quantity);
}
