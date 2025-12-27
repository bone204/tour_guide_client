import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle_catalog.dart';

class RentalVehicle {
  final String licensePlate;
  final int contractId;
  final int? vehicleCatalogId;
  final VehicleCatalog? vehicleCatalog;

  // Base prices
  final double pricePerHour;
  final double pricePerDay;

  // Hourly packages
  final double? priceFor4Hours;
  final double? priceFor8Hours;
  final double? priceFor12Hours;

  // Daily packages
  final double? priceFor2Days;
  final double? priceFor3Days;
  final double? priceFor5Days;
  final double? priceFor7Days;

  final String? requirements;
  final String? description;
  final String? vehicleRegistrationFront;
  final String? vehicleRegistrationBack;

  final String status;
  final String? rejectedReason;
  final String availability;
  final int totalRentals;
  final double averageRating;
  final String createdAt;
  final String updatedAt;

  const RentalVehicle({
    required this.licensePlate,
    required this.contractId,
    this.vehicleCatalogId,
    this.vehicleCatalog,
    required this.pricePerHour,
    required this.pricePerDay,
    this.priceFor4Hours,
    this.priceFor8Hours,
    this.priceFor12Hours,
    this.priceFor2Days,
    this.priceFor3Days,
    this.priceFor5Days,
    this.priceFor7Days,
    this.requirements,
    this.description,
    this.vehicleRegistrationFront,
    this.vehicleRegistrationBack,
    required this.status,
    this.rejectedReason,
    required this.availability,
    required this.totalRentals,
    required this.averageRating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RentalVehicle.fromJson(Map<String, dynamic> json) {
    return RentalVehicle(
      licensePlate: json['licensePlate'] ?? '',
      contractId: json['contractId'] ?? 0,
      vehicleCatalogId: json['vehicleCatalogId'],
      vehicleCatalog:
          json['vehicleCatalog'] != null
              ? VehicleCatalog.fromJson(json['vehicleCatalog'])
              : null,
      pricePerHour:
          double.tryParse(json['pricePerHour']?.toString() ?? '0') ?? 0,
      pricePerDay: double.tryParse(json['pricePerDay']?.toString() ?? '0') ?? 0,
      priceFor4Hours: double.tryParse(json['priceFor4Hours']?.toString() ?? ''),
      priceFor8Hours: double.tryParse(json['priceFor8Hours']?.toString() ?? ''),
      priceFor12Hours: double.tryParse(
        json['priceFor12Hours']?.toString() ?? '',
      ),
      priceFor2Days: double.tryParse(json['priceFor2Days']?.toString() ?? ''),
      priceFor3Days: double.tryParse(json['priceFor3Days']?.toString() ?? ''),
      priceFor5Days: double.tryParse(json['priceFor5Days']?.toString() ?? ''),
      priceFor7Days: double.tryParse(json['priceFor7Days']?.toString() ?? ''),
      requirements: json['requirements'],
      description: json['description'],
      vehicleRegistrationFront: json['vehicleRegistrationFront'],
      vehicleRegistrationBack: json['vehicleRegistrationBack'],
      status: json['status'] ?? 'pending',
      rejectedReason: json['rejectedReason'],
      availability: json['availability'] ?? 'unavailable',
      totalRentals: json['totalRentals'] ?? 0,
      averageRating:
          double.tryParse(json['averageRating']?.toString() ?? '0') ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'licensePlate': licensePlate,
      'contractId': contractId,
      'vehicleCatalogId': vehicleCatalogId,
      'vehicleCatalog': vehicleCatalog?.toJson(),
      'pricePerHour': pricePerHour,
      'pricePerDay': pricePerDay,
      'priceFor4Hours': priceFor4Hours,
      'priceFor8Hours': priceFor8Hours,
      'priceFor12Hours': priceFor12Hours,
      'priceFor2Days': priceFor2Days,
      'priceFor3Days': priceFor3Days,
      'priceFor5Days': priceFor5Days,
      'priceFor7Days': priceFor7Days,
      'requirements': requirements,
      'description': description,
      'vehicleRegistrationFront': vehicleRegistrationFront,
      'vehicleRegistrationBack': vehicleRegistrationBack,
      'status': status,
      'rejectedReason': rejectedReason,
      'availability': availability,
      'totalRentals': totalRentals,
      'averageRating': averageRating,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class RentalVehicleResponse {
  final List<RentalVehicle> items;

  RentalVehicleResponse({required this.items});

  factory RentalVehicleResponse.fromJson(dynamic json) {
    if (json is List) {
      return RentalVehicleResponse(
        items:
            json
                .map((e) => RentalVehicle.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
    } else if (json is Map<String, dynamic>) {
      return RentalVehicleResponse(
        items:
            (json['items'] as List<dynamic>? ?? [])
                .map((e) => RentalVehicle.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
    } else {
      return RentalVehicleResponse(items: []);
    }
  }
}
