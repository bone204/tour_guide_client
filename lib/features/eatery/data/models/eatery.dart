import 'package:equatable/equatable.dart';

class Eatery extends Equatable {
  final int id;
  final String? name;
  final String? province;
  final String? address;
  final String? description;
  final String? phone;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Eatery({
    required this.id,
    this.name,
    this.province,
    this.address,
    this.description,
    this.phone,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Eatery.fromJson(Map<String, dynamic> json) {
    return Eatery(
      id: json['id'] as int,
      name: json['name'] as String?,
      province: json['province'] as String?,
      address: json['address'] as String?,
      description: json['description'] as String?,
      phone: json['phone'] as String?,
      imageUrl: json['imageUrl'] as String?,
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      // Try ISO format first
      try {
        return DateTime.parse(value);
      } catch (_) {}
      // Try dd-MM-yyyy HH:mm:ss format
      try {
        final parts = value.split(' ');
        final dateParts = parts[0].split('-');
        final timeParts = parts.length > 1
            ? parts[1].split(':')
            : ['0', '0', '0'];
        return DateTime(
          int.parse(dateParts[2]), // year
          int.parse(dateParts[1]), // month
          int.parse(dateParts[0]), // day
          int.parse(timeParts[0]), // hour
          int.parse(timeParts[1]), // minute
          timeParts.length > 2 ? int.parse(timeParts[2]) : 0, // second
        );
      } catch (_) {}
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'province': province,
      'address': address,
      'description': description,
      'phone': phone,
      'imageUrl': imageUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    province,
    address,
    description,
    phone,
    imageUrl,
    createdAt,
    updatedAt,
  ];
}
