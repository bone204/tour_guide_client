class VehicleCatalog {
  final int id;
  final String? type;
  final String? brand;
  final String? model;
  final String? color;
  final int? seatingCapacity;
  final String? photo;

  final String? vehicleType;
  final String? fuelType;
  final String? maxSpeed;
  final String? transmission;

  const VehicleCatalog({
    required this.id,
    this.type,
    this.brand,
    this.model,
    this.color,
    this.seatingCapacity,
    this.photo,
    this.vehicleType,
    this.fuelType,
    this.maxSpeed,
    this.transmission,
  });

  factory VehicleCatalog.fromJson(Map<String, dynamic> json) {
    return VehicleCatalog(
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
      vehicleType: json['vehicleType'] as String?,
      fuelType: json['fuelType'] as String?,
      maxSpeed: json['maxSpeed'] as String?,
      transmission: json['transmission'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'brand': brand,
      'model': model,
      'color': color,
      'seatingCapacity': seatingCapacity,
      'photo': photo,
      'vehicleType': vehicleType,
      'fuelType': fuelType,
      'maxSpeed': maxSpeed,
      'transmission': transmission,
    };
  }
}
