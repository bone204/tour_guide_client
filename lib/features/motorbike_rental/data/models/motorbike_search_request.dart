import 'package:intl/intl.dart';

enum RentalType { hourly, daily }

class MotorbikeSearchRequest {
  final RentalType? rentalType;
  final String? vehicleType; // 'bike' or 'car'
  final int? minPrice;
  final int? maxPrice;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? province;
  final double? latitude;
  final double? longitude;

  MotorbikeSearchRequest({
    this.rentalType,
    this.vehicleType,
    this.minPrice,
    this.maxPrice,
    this.startDate,
    this.endDate,
    this.province,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    return {
      if (rentalType != null) 'rentalType': rentalType!.name,
      if (vehicleType != null) 'vehicleType': vehicleType,
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
      if (startDate != null) 'startDate': dateFormat.format(startDate!),
      if (endDate != null) 'endDate': dateFormat.format(endDate!),
      if (province != null) 'province': province,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }
}
