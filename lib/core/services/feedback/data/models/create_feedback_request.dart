class CreateFeedbackRequest {
  final int star;
  final int? destinationId;
  final int? travelRouteId;
  final String? licensePlate;
  final int? cooperationId;
  final String? comment;
  final List<String> images;
  final List<String> videos;

  CreateFeedbackRequest({
    required this.star,
    this.destinationId,
    this.travelRouteId,
    this.licensePlate,
    this.cooperationId,
    this.comment,
    this.images = const [],
    this.videos = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'star': star,
      if (destinationId != null) 'destinationId': destinationId,
      if (travelRouteId != null) 'travelRouteId': travelRouteId,
      if (licensePlate != null) 'licensePlate': licensePlate,
      if (cooperationId != null) 'cooperationId': cooperationId,
      if (comment != null) 'comment': comment,
    };
  }
}
