class VehicleRentalParams {
  final String licensePlate;
  final int contractId;
  final String? vehicleType;
  final String? vehicleBrand;
  final String? vehicleModel;
  final String? vehicleColor;
  final String? manufactureYear;
  final double? pricePerHour;
  final double? pricePerDay;
  final String? requirements;
  final String? vehicleRegistrationFront;
  final String? vehicleRegistrationBack;
  final List<String>? photoUrls;
  final String? description;
  final String status;
  final String availability; 
  final String? externalId;

  const VehicleRentalParams({
    required this.licensePlate,
    required this.contractId,
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
    required this.status,
    required this.availability,
    this.externalId,
  });

  factory VehicleRentalParams.fromJson(Map<String, dynamic> json) {
    return VehicleRentalParams(
      licensePlate: json['licensePlate'] ?? '',
      contractId: json['contractId'] ?? 0,
      vehicleType: json['vehicleType'],
      vehicleBrand: json['vehicleBrand'],
      vehicleModel: json['vehicleModel'],
      vehicleColor: json['vehicleColor'],
      manufactureYear: json['manufactureYear'],
      pricePerHour: (json['pricePerHour'] as num?)?.toDouble(),
      pricePerDay: (json['pricePerDay'] as num?)?.toDouble(),
      requirements: json['requirements'],
      vehicleRegistrationFront: json['vehicleRegistrationFront'],
      vehicleRegistrationBack: json['vehicleRegistrationBack'],
      photoUrls: (json['photoUrls'] as List?)?.map((e) => e.toString()).toList(),
      description: json['description'],
      status: json['status'] ?? 'draft',
      availability: json['availability'] ?? 'available',
      externalId: json['externalId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'licensePlate': licensePlate,
      'contractId': contractId,
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
      'externalId': externalId,
    };
  }

  VehicleRentalParams copyWith({
    String? licensePlate,
    int? contractId,
    String? vehicleType,
    String? vehicleBrand,
    String? vehicleModel,
    String? vehicleColor,
    String? manufactureYear,
    double? pricePerHour,
    double? pricePerDay,
    String? requirements,
    String? vehicleRegistrationFront,
    String? vehicleRegistrationBack,
    List<String>? photoUrls,
    String? description,
    String? status,
    String? availability,
    String? externalId,
  }) {
    return VehicleRentalParams  (
      licensePlate: licensePlate ?? this.licensePlate,
      contractId: contractId ?? this.contractId,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleColor: vehicleColor ?? this.vehicleColor,
      manufactureYear: manufactureYear ?? this.manufactureYear,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      requirements: requirements ?? this.requirements,
      vehicleRegistrationFront:
          vehicleRegistrationFront ?? this.vehicleRegistrationFront,
      vehicleRegistrationBack:
          vehicleRegistrationBack ?? this.vehicleRegistrationBack,
      photoUrls: photoUrls ?? this.photoUrls,
      description: description ?? this.description,
      status: status ?? this.status,
      availability: availability ?? this.availability,
      externalId: externalId ?? this.externalId,
    );
  }
}
