import 'package:tour_guide_app/features/travel_itinerary/data/models/anniversary_detail.dart';

class AnniversaryCheckResponse {
  final int checkedCount;
  final int notificationsSent;
  final List<AnniversaryCheckRoute> matchedRoutes;

  AnniversaryCheckResponse({
    required this.checkedCount,
    required this.notificationsSent,
    required this.matchedRoutes,
  });

  factory AnniversaryCheckResponse.fromJson(Map<String, dynamic> json) {
    return AnniversaryCheckResponse(
      checkedCount: json['checkedCount'] ?? 0,
      notificationsSent: json['notificationsSent'] ?? 0,
      matchedRoutes:
          (json['matchedRoutes'] as List<dynamic>?)
              ?.map((e) => AnniversaryCheckRoute.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class AnniversaryCheckRoute {
  final int id;
  final String name;
  final DateTime? endDate;
  final String period;
  final String userName;
  final List<AnniversaryMedia> aggregatedMedia;

  AnniversaryCheckRoute({
    required this.id,
    required this.name,
    this.endDate,
    required this.period,
    required this.userName,
    required this.aggregatedMedia,
  });

  factory AnniversaryCheckRoute.fromJson(Map<String, dynamic> json) {
    return AnniversaryCheckRoute(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      endDate:
          json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      period: json['period'] ?? '',
      userName: json['userName'] ?? '',
      aggregatedMedia:
          (json['aggregatedMedia'] as List<dynamic>?)
              ?.map((e) => AnniversaryMedia.fromJson(e))
              .toList() ??
          [],
    );
  }
}
