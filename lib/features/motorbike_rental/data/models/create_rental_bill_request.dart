import 'package:intl/intl.dart';

class CreateRentalBillRequest {
  final String rentalType;
  final String vehicleType;
  final String durationPackage;
  final DateTime startDate;
  final DateTime endDate;
  final String? location;
  final List<RentalBillDetailRequest> details;

  CreateRentalBillRequest({
    required this.rentalType,
    required this.vehicleType,
    required this.durationPackage,
    required this.startDate,
    required this.endDate,
    this.location,
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
