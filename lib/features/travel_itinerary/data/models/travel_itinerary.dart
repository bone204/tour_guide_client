import 'package:tour_guide_app/features/destination/data/models/destination.dart';

/// Model cho một ngày trong lộ trình
class ItineraryDay {
  final int dayNumber;
  final String date; // Format: 'yyyy-MM-dd'
  final List<Destination> destinations;
  final String? notes;

  const ItineraryDay({
    required this.dayNumber,
    required this.date,
    required this.destinations,
    this.notes,
  });

  ItineraryDay copyWith({
    int? dayNumber,
    String? date,
    List<Destination>? destinations,
    String? notes,
  }) {
    return ItineraryDay(
      dayNumber: dayNumber ?? this.dayNumber,
      date: date ?? this.date,
      destinations: destinations ?? this.destinations,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayNumber': dayNumber,
      'date': date,
      'destinations': destinations.map((d) => d.toJson()).toList(),
      'notes': notes,
    };
  }

  factory ItineraryDay.fromJson(Map<String, dynamic> json) {
    return ItineraryDay(
      dayNumber: json['dayNumber'] ?? 0,
      date: json['date'] ?? '',
      destinations: (json['destinations'] as List?)
              ?.map((e) => Destination.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      notes: json['notes'],
    );
  }
}

/// Model cho toàn bộ lộ trình du lịch
class TravelItinerary {
  final String id; // Local ID for draft itineraries
  final String title;
  final String province;
  final DateTime startDate;
  final DateTime endDate;
  final List<ItineraryDay> days;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TravelItinerary({
    required this.id,
    required this.title,
    required this.province,
    required this.startDate,
    required this.endDate,
    required this.days,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  int get totalDays => days.length;
  int get totalDestinations =>
      days.fold(0, (sum, day) => sum + day.destinations.length);

  TravelItinerary copyWith({
    String? id,
    String? title,
    String? province,
    DateTime? startDate,
    DateTime? endDate,
    List<ItineraryDay>? days,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TravelItinerary(
      id: id ?? this.id,
      title: title ?? this.title,
      province: province ?? this.province,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      days: days ?? this.days,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'province': province,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'days': days.map((d) => d.toJson()).toList(),
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TravelItinerary.fromJson(Map<String, dynamic> json) {
    return TravelItinerary(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      province: json['province'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      days: (json['days'] as List?)
              ?.map((e) => ItineraryDay.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}


