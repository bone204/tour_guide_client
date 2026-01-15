import 'package:tour_guide_app/features/cooperations/data/models/cooperation.dart';

class HotelRoom {
  final int id;
  final String name;
  final Cooperation? cooperation;
  final int numberOfBeds;
  final int maxPeople;
  final double? area;
  final double price;
  final int numberOfRooms;
  final String? photo;
  final String? description;
  final List<String> amenities;
  final String status;
  final int totalBookings;
  final double totalRevenue;
  final int? availableRooms;
  final DateTime createdAt;
  final DateTime updatedAt;

  HotelRoom({
    required this.id,
    required this.name,
    this.cooperation,
    required this.numberOfBeds,
    required this.maxPeople,
    this.area,
    required this.price,
    required this.numberOfRooms,
    this.photo,
    this.description,
    required this.amenities,
    required this.status,
    required this.totalBookings,
    required this.totalRevenue,
    this.availableRooms,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isAvailable =>
      status.toUpperCase() == 'AVAILABLE' ||
      (availableRooms != null && availableRooms! > 0);

  factory HotelRoom.fromJson(Map<String, dynamic> json) {
    return HotelRoom(
      id: json['id'],
      name: json['name'],
      cooperation:
          json['cooperation'] != null
              ? Cooperation.fromJson(json['cooperation'])
              : null,
      numberOfBeds: json['numberOfBeds'] ?? 1,
      maxPeople: json['maxPeople'] ?? 1,
      area:
          json['area'] != null
              ? double.tryParse(json['area'].toString())
              : null,
      price: double.parse(json['price'].toString()),
      numberOfRooms: json['numberOfRooms'] ?? 1,
      photo: json['photo'],
      description: json['description'],
      amenities: List<String>.from(json['amenities'] ?? []),
      status: json['status'],
      totalBookings: json['totalBookings'] ?? 0,
      totalRevenue: double.parse((json['totalRevenue'] ?? 0).toString()),
      availableRooms: json['availableRooms'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
