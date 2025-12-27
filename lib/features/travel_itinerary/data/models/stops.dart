import 'package:tour_guide_app/features/destination/data/models/destination.dart';

class Stop {
  final int id;
  final int dayOrder;
  final int sequence;
  final String status;
  final int travelPoints;
  final String startTime;
  final String endTime;
  final String notes;
  final Destination? destination;
  final List<String> images;
  final List<String> videos;
  final String createdAt;
  final String updatedAt;

  const Stop({
    required this.id,
    required this.dayOrder,
    required this.sequence,
    required this.status,
    required this.travelPoints,
    required this.startTime,
    required this.endTime,
    required this.notes,
    this.destination,
    required this.images,
    required this.videos,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      dayOrder: int.tryParse(json['dayOrder']?.toString() ?? '0') ?? 0,
      sequence: int.tryParse(json['sequence']?.toString() ?? '0') ?? 0,
      status: json['status'] ?? '',
      travelPoints: int.tryParse(json['travelPoints']?.toString() ?? '0') ?? 0,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      notes: json['notes'] ?? '',
      destination:
          json['destination'] != null
              ? Destination.fromJson(json['destination'])
              : null,
      images:
          (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      videos:
          (json['videos'] as List?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayOrder': dayOrder,
      'sequence': sequence,
      'status': status,
      'travelPoints': travelPoints,
      'startTime': startTime,
      'endTime': endTime,
      'notes': notes,
      'destination': destination?.toJson(),
      'images': images,
      'videos': videos,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
