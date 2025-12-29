class FeedbackQuery {
  final int? userId;
  final int? destinationId;
  final int? travelRouteId;
  final int? cooperationId;
  final String? status;
  final int? limit;
  final int? offset;

  const FeedbackQuery({
    this.userId,
    this.destinationId,
    this.travelRouteId,
    this.cooperationId,
    this.status,
    this.limit,
    this.offset,
  });

  Map<String, dynamic> toQuery() {
    return {
      if (userId != null) 'userId': userId,
      if (destinationId != null) 'destinationId': destinationId,
      if (travelRouteId != null) 'travelRouteId': travelRouteId,
      if (cooperationId != null) 'cooperationId': cooperationId,
      if (status != null) 'status': status,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
  }
}
