class AnniversaryDetail {
  final int routeId;
  final String name;
  final String period;
  final String message;
  final List<AnniversaryMedia> media;

  AnniversaryDetail({
    required this.routeId,
    required this.name,
    required this.period,
    required this.message,
    required this.media,
  });

  factory AnniversaryDetail.fromJson(Map<String, dynamic> json) {
    return AnniversaryDetail(
      routeId: json['routeId'] ?? 0,
      name: json['name'] ?? '',
      period: json['period'] ?? '',
      message: json['message'] ?? '',
      media:
          (json['media'] as List<dynamic>?)
              ?.map((e) => AnniversaryMedia.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class AnniversaryMedia {
  final String url;
  final String type; // 'image' or 'video'
  final int stopId;

  AnniversaryMedia({
    required this.url,
    required this.type,
    required this.stopId,
  });

  factory AnniversaryMedia.fromJson(Map<String, dynamic> json) {
    return AnniversaryMedia(
      url: json['url'] ?? '',
      type: json['type'] ?? 'image',
      stopId: json['stopId'] ?? 0,
    );
  }
}
