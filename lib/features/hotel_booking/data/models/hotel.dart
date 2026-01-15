import 'package:tour_guide_app/features/hotel_booking/data/models/room.dart';

class Hotel {
  final int id;
  final String name;
  final String? type;
  final String? address;
  final String? province;
  final double? latitude;
  final double? longitude;
  final String? photo;
  final String? introduction;
  final double averageRating;
  final int totalBookings;
  final List<HotelRoom> rooms;

  const Hotel({
    required this.id,
    required this.name,
    this.type,
    this.address,
    this.province,
    this.latitude,
    this.longitude,
    this.photo,
    this.introduction,
    this.averageRating = 0.0,
    this.totalBookings = 0,
    this.rooms = const [],
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'],
      address: json['address'],
      province: json['province'],
      latitude:
          json['latitude'] != null
              ? double.tryParse(json['latitude'].toString())
              : null,
      longitude:
          json['longitude'] != null
              ? double.tryParse(json['longitude'].toString())
              : null,
      photo: json['photo'],
      introduction: json['introduction'],
      averageRating:
          double.tryParse((json['averageRating'] ?? 0).toString()) ?? 0.0,
      totalBookings: json['totalBookings'] ?? 0,
      rooms:
          (json['rooms'] as List?)
              ?.map((e) => HotelRoom.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'address': address,
      'province': province,
      'latitude': latitude,
      'longitude': longitude,
      'photo': photo,
      'introduction': introduction,
      'averageRating': averageRating,
      'totalBookings': totalBookings,
      'rooms': rooms.map((e) => e.toJson()).toList(),
    };
  }
}
