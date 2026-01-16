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
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      numberOfRooms: json['numberOfRooms'] ?? 1,
      photo: json['photo'],
      description: json['description'],
      amenities: List<String>.from(json['amenities'] ?? []),
      status: json['status'] ?? 'active',
      totalBookings: json['totalBookings'] ?? 0,
      totalRevenue:
          double.tryParse((json['totalRevenue'] ?? 0).toString()) ?? 0.0,
      availableRooms: json['availableRooms'],
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cooperation': cooperation?.toJson(),
      'numberOfBeds': numberOfBeds,
      'maxPeople': maxPeople,
      'area': area,
      'price': price,
      'numberOfRooms': numberOfRooms,
      'photo': photo,
      'description': description,
      'amenities': amenities,
      'status': status,
      'totalBookings': totalBookings,
      'totalRevenue': totalRevenue,
      'availableRooms': availableRooms,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class RoomBooking {
  final HotelRoom room;
  final int quantity;

  RoomBooking({required this.room, required this.quantity});

  double get totalPrice => room.price * quantity;
}
