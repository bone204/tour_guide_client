import 'package:intl/intl.dart';

class CreateRentalBillRequest {
  final String rentalType;
  final String vehicleType;
  final String durationPackage;
  final DateTime startDate;
  final DateTime endDate;
  final String? location;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final List<RentalBillDetailRequest> details;

  CreateRentalBillRequest({
    required this.rentalType,
    required this.vehicleType,
    required this.durationPackage,
    required this.startDate,
    required this.endDate,
    this.location,
    this.pickupLatitude,
    this.pickupLongitude,
    required this.details,
  });

  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    return {
      'rentalType': rentalType,
      'vehicleType': vehicleType,
      'durationPackage': durationPackage,
      'startDate': formatter.format(startDate),
      'endDate': formatter.format(endDate),
      if (location != null) 'location': location,
      if (pickupLatitude != null) 'pickupLatitude': pickupLatitude,
      if (pickupLongitude != null) 'pickupLongitude': pickupLongitude,
      'details': details.map((e) => e.toJson()).toList(),
    };
  }
}

class RentalBillDetailRequest {
  final String licensePlate;
  final String? note;

  RentalBillDetailRequest({required this.licensePlate, this.note});

  Map<String, dynamic> toJson() {
    return {'licensePlate': licensePlate, if (note != null) 'note': note};
  }
}
