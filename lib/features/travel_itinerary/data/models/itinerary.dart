import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/user.dart';

class Itinerary {
  final int id;
  final User user;
  final String name;
  final String province;
  final int numberOfDays;
  final String startDate;
  final String endDate;
  final List<Stop> stops;
  final int totalTravelPoints;
  final double averageRating;
  final bool shared;
  final String status;
  final String createdAt;
  final String updatedAt;
  final bool isLiked;
  final int likeCount;

  const Itinerary({
    required this.id,
    required this.user,
    required this.name,
    required this.province,
    required this.numberOfDays,
    required this.startDate,
    required this.endDate,
    required this.stops,
    required this.totalTravelPoints,
    required this.averageRating,
    required this.shared,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.isLiked = false,
    this.likeCount = 0,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      id: json['id'] ?? 0,
      user: User.fromJson(json['user'] ?? {}),
      name: json['name'] ?? '',
      province: json['province'] ?? '',
      numberOfDays: json['numberOfDays'] ?? 0,
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      stops:
          (json['stops'] as List? ?? []).map((e) => Stop.fromJson(e)).toList(),
      totalTravelPoints: json['totalTravelPoints'] ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0,
      shared: json['shared'] ?? false,
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      isLiked: json['isLiked'] ?? false,
      likeCount: json['favouriteTimes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'name': name,
      'province': province,
      'numberOfDays': numberOfDays,
      'startDate': startDate,
      'endDate': endDate,
      'stops': stops.map((e) => e.toJson()).toList(),
      'totalTravelPoints': totalTravelPoints,
      'averageRating': averageRating,
      'shared': shared,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isLiked': isLiked,
      'likeCount': likeCount,
    };
  }

  Itinerary copyWith({
    int? id,
    User? user,
    String? name,
    String? province,
    int? numberOfDays,
    String? startDate,
    String? endDate,
    List<Stop>? stops,
    int? totalTravelPoints,
    double? averageRating,
    bool? shared,
    String? status,
    String? createdAt,
    String? updatedAt,
    bool? isLiked,
    int? likeCount,
  }) {
    return Itinerary(
      id: id ?? this.id,
      user: user ?? this.user,
      name: name ?? this.name,
      province: province ?? this.province,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      stops: stops ?? this.stops,
      totalTravelPoints: totalTravelPoints ?? this.totalTravelPoints,
      averageRating: averageRating ?? this.averageRating,
      shared: shared ?? this.shared,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
    );
  }
}

class ItineraryResponse {
  final List<Itinerary> items;

  ItineraryResponse({required this.items});

  factory ItineraryResponse.fromJson(dynamic json) {
    if (json is List) {
      return ItineraryResponse(
        items:
            json
                .map((e) => Itinerary.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
    } else if (json is Map<String, dynamic>) {
      return ItineraryResponse(
        items:
            (json['items'] as List<dynamic>? ?? [])
                .map((e) => Itinerary.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
    } else {
      return ItineraryResponse(items: []);
    }
  }

  Map<String, dynamic> toJson() {
    return {'items': items.map((e) => e.toJson()).toList()};
  }
}
