class Stop {
  final int id;
  final int dayOrder;
  final int sequence;
  final String status;
  final int travelPoints;
  final String startTime;
  final String endTime;
  final String notes;
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
    required this.images,
    required this.videos,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      id: json['id'] ?? 0,
      dayOrder: json['dayOrder'] ?? 0,
      sequence: json['sequence'] ?? 0,
      status: json['status'] ?? '',
      travelPoints: json['travelPoints'] ?? 0,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      notes: json['notes'] ?? '',
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      videos: (json['videos'] as List?)?.map((e) => e.toString()).toList() ?? [],
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
      'images': images,
      'videos': videos,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
