class VehicleCatalogInfo {
  final int id;
  final String? type;
  final String? brand;
  final String? model;
  final String? color;
  final int? seatingCapacity;
  final String? photo;

  const VehicleCatalogInfo({
    required this.id,
    this.type,
    this.brand,
    this.model,
    this.color,
    this.seatingCapacity,
    this.photo,
  });

  factory VehicleCatalogInfo.fromJson(Map<String, dynamic> json) {
    return VehicleCatalogInfo(
      id:
          json['id'] is int
              ? json['id'] as int
              : int.tryParse('${json['id']}') ?? 0,
      type: json['type'] as String?,
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      color: json['color'] as String?,
      seatingCapacity:
          json['seatingCapacity'] is int
              ? json['seatingCapacity'] as int
              : int.tryParse('${json['seatingCapacity'] ?? ''}'),
      photo: json['photo'] as String?,
    );
  }
}

enum RentalVehicleApprovalStatus {
  pending,
  approved,
  rejected,
  inactive;

  String get value => name;

  static RentalVehicleApprovalStatus fromString(String? status) {
    if (status == null) return RentalVehicleApprovalStatus.pending;
    return RentalVehicleApprovalStatus.values.firstWhere(
      (item) => item.value == status.toLowerCase(),
      orElse: () => RentalVehicleApprovalStatus.pending,
    );
  }
}

enum RentalVehicleAvailabilityStatus {
  available,
  rented,
  maintenance;

  String get value => name;

  static RentalVehicleAvailabilityStatus fromString(String? status) {
    if (status == null) return RentalVehicleAvailabilityStatus.available;
    return RentalVehicleAvailabilityStatus.values.firstWhere(
      (item) => item.value == status.toLowerCase(),
      orElse: () => RentalVehicleAvailabilityStatus.available,
    );
  }
}

class Vehicle {
  final String licensePlate;
  final int contractId;
  final VehicleCatalogInfo? vehicleCatalog;
  final int? vehicleCatalogId;
  final double pricePerHour;
  final double pricePerDay;
  final String? requirements;
  final String? description;
  final RentalVehicleApprovalStatus status;
  final String? rejectedReason;
  final RentalVehicleAvailabilityStatus availability;
  final int totalRentals;
  final double averageRating;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Vehicle({
    required this.licensePlate,
    required this.contractId,
    required this.pricePerHour,
    required this.pricePerDay,
    required this.status,
    required this.availability,
    required this.totalRentals,
    required this.averageRating,
    this.vehicleCatalog,
    this.vehicleCatalogId,
    this.requirements,
    this.description,
    this.rejectedReason,
    this.createdAt,
    this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    final catalogJson = json['vehicleCatalog'];
    return Vehicle(
      licensePlate: json['licensePlate']?.toString() ?? '',
      contractId: _parseInt(json['contractId']) ?? 0,
      vehicleCatalogId: _parseInt(json['vehicleCatalogId']),
      vehicleCatalog:
          catalogJson is Map<String, dynamic>
              ? VehicleCatalogInfo.fromJson(catalogJson)
              : null,
      pricePerHour: double.tryParse('${json['pricePerHour'] ?? '0'}') ?? 0,
      pricePerDay: double.tryParse('${json['pricePerDay'] ?? '0'}') ?? 0,
      requirements: json['requirements'] as String?,
      description: json['description'] as String?,
      status: RentalVehicleApprovalStatus.fromString(json['status'] as String?),
      rejectedReason: json['rejectedReason'] as String?,
      availability: RentalVehicleAvailabilityStatus.fromString(
        json['availability'] as String?,
      ),
      totalRentals: _parseInt(json['totalRentals']) ?? 0,
      averageRating: double.tryParse('${json['averageRating'] ?? '0'}') ?? 0,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'licensePlate': licensePlate,
      'contractId': contractId,
      'vehicleCatalogId': vehicleCatalogId,
      'vehicleCatalog':
          vehicleCatalog == null
              ? null
              : {
                'id': vehicleCatalog!.id,
                'type': vehicleCatalog!.type,
                'brand': vehicleCatalog!.brand,
                'model': vehicleCatalog!.model,
                'color': vehicleCatalog!.color,
                'seatingCapacity': vehicleCatalog!.seatingCapacity,
                'photo': vehicleCatalog!.photo,
              },
      'pricePerHour': pricePerHour,
      'pricePerDay': pricePerDay,
      'requirements': requirements,
      'description': description,
      'status': status.value,
      'rejectedReason': rejectedReason,
      'availability': availability.value,
      'totalRentals': totalRentals,
      'averageRating': averageRating,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
