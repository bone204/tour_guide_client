class AddFeedbackRequest {
  final int star;
  final int? destinationId;
  final int? travelRouteId;
  final String? licensePlate;
  final int? cooperationId;
  final String? comment;
  final List<String> photos;
  final List<String> videos;

  AddFeedbackRequest({
    required this.star,
    this.destinationId,
    this.travelRouteId,
    this.licensePlate,
    this.cooperationId,
    this.comment,
    this.photos = const [],
    this.videos = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'star': star,
      'destinationId': destinationId,
      'travelRouteId': travelRouteId,
      'licensePlate': licensePlate,
      'cooperationId': cooperationId,
      'comment': comment,
      'photos': photos,
      'videos': videos,
    };
  }
}
