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
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : null,
    );
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
