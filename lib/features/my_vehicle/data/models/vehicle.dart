class Vehicle {
  final String licensePlate;
  final String? externalId;
  final Map<String, dynamic>? contract;
  final int contractId;
  final Map<String, dynamic>? vehicleInformation;
  final int? vehicleInformationId;
  final String? vehicleType;
  final String? vehicleBrand;
  final String? vehicleModel;
  final String? vehicleColor;
  final String? manufactureYear;
  final String? pricePerHour;
  final String? pricePerDay;
  final String? requirements;
  final String? vehicleRegistrationFront;
  final String? vehicleRegistrationBack;
  final List<String>? photoUrls;
  final String? description;
  final String? status;
  final String? statusReason;
  final String? availability;
  final int totalRentals;
  final String averageRating;
  final String? createdAt;
  final String? updatedAt;

  const Vehicle({
    required this.licensePlate,
    this.externalId,
    this.contract,
    required this.contractId,
    this.vehicleInformation,
    this.vehicleInformationId,
    this.vehicleType,
    this.vehicleBrand,
    this.vehicleModel,
    this.vehicleColor,
    this.manufactureYear,
    this.pricePerHour,
    this.pricePerDay,
    this.requirements,
    this.vehicleRegistrationFront,
    this.vehicleRegistrationBack,
    this.photoUrls,
    this.description,
    this.status,
    this.statusReason,
    this.availability,
    required this.totalRentals,
    required this.averageRating,
    this.createdAt,
    this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      licensePlate: json['licensePlate']?.toString() ?? '',
      externalId: json['externalId']?.toString(),
      contract: json['contract'] != null && json['contract'] is Map
          ? json['contract'] as Map<String, dynamic>
          : null,
      contractId: _parseInt(json['contractId']) ?? 0,
      vehicleInformation: json['vehicleInformation'] != null && json['vehicleInformation'] is Map
          ? json['vehicleInformation'] as Map<String, dynamic>
          : null,
      vehicleInformationId: _parseInt(json['vehicleInformationId']),
      vehicleType: json['vehicleType']?.toString(),
      vehicleBrand: json['vehicleBrand']?.toString(),
      vehicleModel: json['vehicleModel']?.toString(),
      vehicleColor: json['vehicleColor']?.toString(),
      manufactureYear: json['manufactureYear']?.toString(),
      pricePerHour: json['pricePerHour']?.toString(),
      pricePerDay: json['pricePerDay']?.toString(),
      requirements: json['requirements']?.toString(),
      vehicleRegistrationFront: json['vehicleRegistrationFront']?.toString(),
      vehicleRegistrationBack: json['vehicleRegistrationBack']?.toString(),
      photoUrls: json['photoUrls'] != null && json['photoUrls'] is List
          ? List<String>.from(json['photoUrls'].map((e) => e.toString()))
          : null,
      description: json['description']?.toString(),
      status: json['status']?.toString(),
      statusReason: json['statusReason']?.toString(),
      availability: json['availability']?.toString(),
      totalRentals: _parseInt(json['totalRentals']) ?? 0,
      averageRating: json['averageRating']?.toString() ?? '0.00',
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'licensePlate': licensePlate,
      'externalId': externalId,
      'contractId': contractId,
      'vehicleInformationId': vehicleInformationId,
      'vehicleType': vehicleType,
      'vehicleBrand': vehicleBrand,
      'vehicleModel': vehicleModel,
      'vehicleColor': vehicleColor,
      'manufactureYear': manufactureYear,
      'pricePerHour': pricePerHour,
      'pricePerDay': pricePerDay,
      'requirements': requirements,
      'vehicleRegistrationFront': vehicleRegistrationFront,
      'vehicleRegistrationBack': vehicleRegistrationBack,
      'photoUrls': photoUrls,
      'description': description,
      'status': status,
      'availability': availability,
    };
  }
}

