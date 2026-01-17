import 'package:tour_guide_app/features/restaurant/data/models/restaurant_table_search_response.dart';

class RestaurantSearchResponse {
  final int id;
  final String name;
  final String? code;
  final String? type;
  final int numberOfObjects;
  final int numberOfObjectTypes;
  final String? bossName;
  final String? bossPhone;
  final String? bossEmail;
  final String? address;
  final String? district;
  final String? city;
  final String? province;
  final String? photo;
  final String? extension;
  final String? introduction;
  final String? contractDate;
  final String? contractTerm;
  final String? bankAccountNumber;
  final String? bankAccountName;
  final String? bankName;
  final int bookingTimes;
  final String revenue;
  final String averageRating;
  final bool active;
  final String? createdAt;
  final String? updatedAt;
  final double? latitude;
  final double? longitude;
  final List<RestaurantTableSearchResponse> restaurantTables;

  const RestaurantSearchResponse({
    required this.id,
    required this.name,
    this.code,
    this.type,
    this.numberOfObjects = 0,
    this.numberOfObjectTypes = 0,
    this.bossName,
    this.bossPhone,
    this.bossEmail,
    this.address,
    this.district,
    this.city,
    this.province,
    this.photo,
    this.extension,
    this.introduction,
    this.contractDate,
    this.contractTerm,
    this.bankAccountNumber,
    this.bankAccountName,
    this.bankName,
    this.bookingTimes = 0,
    this.revenue = "0",
    this.averageRating = "0",
    this.active = true,
    this.createdAt,
    this.updatedAt,
    this.latitude,
    this.longitude,
    this.restaurantTables = const [],
  });

  factory RestaurantSearchResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantSearchResponse(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'],
      type: json['type'],
      numberOfObjects: json['numberOfObjects'] ?? 0,
      numberOfObjectTypes: json['numberOfObjectTypes'] ?? 0,
      bossName: json['bossName'],
      bossPhone: json['bossPhone'],
      bossEmail: json['bossEmail'],
      address: json['address'],
      district: json['district'],
      city: json['city'],
      province: json['province'],
      photo: json['photo'],
      extension: json['extension'],
      introduction: json['introduction'],
      contractDate: json['contractDate'],
      contractTerm: json['contractTerm'],
      bankAccountNumber: json['bankAccountNumber'],
      bankAccountName: json['bankAccountName'],
      bankName: json['bankName'],
      bookingTimes: json['bookingTimes'] ?? 0,
      revenue: json['revenue']?.toString() ?? "0",
      averageRating: json['averageRating']?.toString() ?? "0",
      active: json['active'] ?? true,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      latitude:
          json['latitude'] != null
              ? double.tryParse(json['latitude'].toString())
              : null,
      longitude:
          json['longitude'] != null
              ? double.tryParse(json['longitude'].toString())
              : null,
      restaurantTables:
          json['restaurantTables'] != null
              ? (json['restaurantTables'] as List)
                  .map((e) => RestaurantTableSearchResponse.fromJson(e))
                  .toList()
              : [],
    );
  }
}
