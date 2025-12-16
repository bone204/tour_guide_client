class ItineraryQuery {
  final String? q;
  final String? province;
  final int? userId;
  final bool? shared;

  const ItineraryQuery({
    this.q,
    this.province,
    this.userId,
    this.shared,
  });

  Map<String, dynamic> toQuery() {
    return {
      if (q != null) 'q': q,
      if (province != null) 'province': province,
      if (userId != null) 'userId': userId,
      if (shared != null) 'shared': shared,
    };
  }
}
