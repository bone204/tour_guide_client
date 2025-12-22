class AddVehicleRequest {
  final String licensePlate;
  final int contractId;
  final int vehicleCatalogId;

  final double pricePerHour;
  final double pricePerDay;

  final double? priceFor4Hours;
  final double? priceFor8Hours;
  final double? priceFor12Hours;

  final double? priceFor2Days;
  final double? priceFor3Days;
  final double? priceFor5Days;
  final double? priceFor7Days;

  final String? requirements;
  final String? description;

  // For file uploads
  final dynamic vehicleRegistrationFront;
  final dynamic vehicleRegistrationBack;

  AddVehicleRequest({
    required this.licensePlate,
    required this.contractId,
    required this.vehicleCatalogId,
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
    required this.vehicleRegistrationFront,
    required this.vehicleRegistrationBack,
  });

  Map<String, dynamic> toJson() {
    return {
      'licensePlate': licensePlate,
      'contractId': contractId,
      'vehicleCatalogId': vehicleCatalogId,
      'pricePerHour': pricePerHour,
      'pricePerDay': pricePerDay,
      if (priceFor4Hours != null) 'priceFor4Hours': priceFor4Hours,
      if (priceFor8Hours != null) 'priceFor8Hours': priceFor8Hours,
      if (priceFor12Hours != null) 'priceFor12Hours': priceFor12Hours,
      if (priceFor2Days != null) 'priceFor2Days': priceFor2Days,
      if (priceFor3Days != null) 'priceFor3Days': priceFor3Days,
      if (priceFor5Days != null) 'priceFor5Days': priceFor5Days,
      if (priceFor7Days != null) 'priceFor7Days': priceFor7Days,
      if (requirements != null) 'requirements': requirements,
      if (description != null) 'description': description,
      'vehicleRegistrationFront': vehicleRegistrationFront,
      'vehicleRegistrationBack': vehicleRegistrationBack,
    };
  }
}
