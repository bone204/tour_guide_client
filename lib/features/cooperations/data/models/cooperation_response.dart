import 'package:tour_guide_app/features/cooperations/data/models/cooperation.dart';

class CooperationResponse {
  final List<Cooperation> items;

  CooperationResponse({required this.items});

  factory CooperationResponse.fromJson(dynamic json) {
    if (json is List) {
      return CooperationResponse(
        items:
            json
                .map((e) => Cooperation.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
    } else if (json is Map<String, dynamic>) {
      return CooperationResponse(
        items:
            (json['items'] as List<dynamic>? ?? [])
                .map((e) => Cooperation.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
    } else {
      return CooperationResponse(items: []);
    }
  }

  Map<String, dynamic> toJson() {
    return {"items": items.map((e) => e.toJson()).toList()};
  }
}
