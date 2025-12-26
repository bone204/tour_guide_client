import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/user.dart';

class Itinerary {
  final int id;
  final User user;
  final String name;
  final String province;
  final String startDate;
  final String endDate;
  final String status;
  final int totalTravelPoints;
  final double averageRating;
  final int likeCount; // Maps to favouriteTimes
  final bool isPublic; // Renamed from shared
  final bool isEdited; // New field
  final String createdAt;
  final String updatedAt;
  final List<Stop> stops;
  final Itinerary? clonedFromRoute; // New field
  final int numberOfDays; // Computed

  const Itinerary({
    required this.id,
    required this.user,
    required this.name,
    required this.province,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.totalTravelPoints,
    required this.averageRating,
    required this.likeCount,
    required this.isPublic,
    required this.isEdited,
    required this.createdAt,
    required this.updatedAt,
    required this.stops,
    this.clonedFromRoute,
    required this.numberOfDays,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    int days = 0;
    if (json['startDate'] != null && json['endDate'] != null) {
      try {
        final start = DateTime.parse(json['startDate']);
        final end = DateTime.parse(json['endDate']);
        days = end.difference(start).inDays + 1;
      } catch (_) {}
    }

    return Itinerary(
      id: json['id'] ?? 0,
      user: User.fromJson(json['user'] ?? {}),
      name: json['name'] ?? '',
      province: json['province'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      status: json['status'] ?? '',
      totalTravelPoints: json['totalTravelPoints'] ?? 0,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      likeCount: json['favouriteTimes'] ?? 0,
      isPublic: json['isPublic'] ?? false,
      isEdited: json['isEdited'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      stops:
          (json['stops'] as List?)
              ?.map((e) => Stop.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      clonedFromRoute:
          json['clonedFromRoute'] != null
              ? Itinerary.fromJson(json['clonedFromRoute'])
              : null,
      numberOfDays: days,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'name': name,
      'province': province,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'totalTravelPoints': totalTravelPoints,
      'averageRating': averageRating,
      'favouriteTimes': likeCount,
      'isPublic': isPublic,
      'isEdited': isEdited,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'stops': stops.map((e) => e.toJson()).toList(),
      'clonedFromRoute': clonedFromRoute?.toJson(),
    };
  }

  Itinerary copyWith({
    int? id,
    User? user,
    String? name,
    String? province,
    String? startDate,
    String? endDate,
    List<Stop>? stops,
    String? status,
    int? totalTravelPoints,
    double? averageRating,
    int? likeCount,
    bool? isPublic,
    bool? isEdited,
    String? createdAt,
    String? updatedAt,
    Itinerary? clonedFromRoute,
  }) {
    int days = numberOfDays;
    if (startDate != null && endDate != null) {
      try {
        final start = DateTime.parse(startDate);
        final end = DateTime.parse(endDate);
        days = end.difference(start).inDays + 1;
      } catch (_) {}
    } else if ((startDate != null || endDate != null) &&
        (this.startDate.isNotEmpty && this.endDate.isNotEmpty)) {
      // Recompute if one of them changes
      final s = startDate ?? this.startDate;
      final e = endDate ?? this.endDate;
      try {
        final start = DateTime.parse(s);
        final end = DateTime.parse(e);
        days = end.difference(start).inDays + 1;
      } catch (_) {}
    }

    return Itinerary(
      id: id ?? this.id,
      user: user ?? this.user,
      name: name ?? this.name,
      province: province ?? this.province,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      totalTravelPoints: totalTravelPoints ?? this.totalTravelPoints,
      averageRating: averageRating ?? this.averageRating,
      likeCount: likeCount ?? this.likeCount,
      isPublic: isPublic ?? this.isPublic,
      isEdited: isEdited ?? this.isEdited,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      stops: stops ?? this.stops,
      clonedFromRoute: clonedFromRoute ?? this.clonedFromRoute,
      numberOfDays: days,
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
