class AddFeedbackRequest {
  final int star;
  final int? userId;
  final String? userUid;
  final int? destinationId;
  final int? travelRouteId;
  final String? licensePlate;
  final int? cooperationId;
  final String? comment;
  final List<String> photos; 
  final List<String> videos;

  AddFeedbackRequest({
    required this.star,
    this.userId,
    this.userUid,
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
      'userId': userId,
      'userUid': userUid,
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
