import 'package:tour_guide_app/features/my_vehicle_v1/data/models/vehicle.dart';

class VehicleRentalParams {
  final String licensePlate;
  final int contractId;
  final int? vehicleCatalogId;
  final double pricePerHour;
  final double pricePerDay;
  final String? requirements;
  final String? description;
  final RentalVehicleApprovalStatus? status;
  final RentalVehicleAvailabilityStatus? availability;

  const VehicleRentalParams({
    required this.licensePlate,
    required this.contractId,
    required this.pricePerHour,
    required this.pricePerDay,
    this.vehicleCatalogId,
    this.requirements,
    this.description,
    this.status,
    this.availability,
  });

  factory VehicleRentalParams.fromJson(Map<String, dynamic> json) {
    return VehicleRentalParams(
      licensePlate: json['licensePlate'] as String? ?? '',
      contractId: json['contractId'] as int? ?? 0,
      vehicleCatalogId: json['vehicleCatalogId'] as int?,
      pricePerHour: (json['pricePerHour'] as num?)?.toDouble() ?? 0,
      pricePerDay: (json['pricePerDay'] as num?)?.toDouble() ?? 0,
      requirements: json['requirements'] as String?,
      description: json['description'] as String?,
      status:
          json['status'] != null
              ? RentalVehicleApprovalStatus.fromString(
                json['status'] as String?,
              )
              : null,
      availability:
          json['availability'] != null
              ? RentalVehicleAvailabilityStatus.fromString(
                json['availability'] as String?,
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'licensePlate': licensePlate,
      'contractId': contractId,
      'vehicleCatalogId': vehicleCatalogId,
      'pricePerHour': pricePerHour,
      'pricePerDay': pricePerDay,
      'requirements': requirements,
      'description': description,
      if (status != null) 'status': status!.value,
      if (availability != null) 'availability': availability!.value,
    };
  }

  VehicleRentalParams copyWith({
    String? licensePlate,
    int? contractId,
    int? vehicleCatalogId,
    double? pricePerHour,
    double? pricePerDay,
    String? requirements,
    String? description,
    RentalVehicleApprovalStatus? status,
    RentalVehicleAvailabilityStatus? availability,
  }) {
    return VehicleRentalParams(
      licensePlate: licensePlate ?? this.licensePlate,
      contractId: contractId ?? this.contractId,
      vehicleCatalogId: vehicleCatalogId ?? this.vehicleCatalogId,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      requirements: requirements ?? this.requirements,
      description: description ?? this.description,
      status: status ?? this.status,
      availability: availability ?? this.availability,
    );
  }
}
