import 'package:tour_guide_app/features/destination/data/models/destination.dart';

class DestinationResponse {
  final List<Destination> items;

  DestinationResponse({
    required this.items,
  });

  factory DestinationResponse.fromJson(dynamic json) {
    // Handle both array and object response
    if (json is List) {
      // API trả về array trực tiếp: [{...}, {...}]
      return DestinationResponse(
        items: json
            .map((e) => Destination.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } else if (json is Map<String, dynamic>) {
      // API trả về object với field items: {"items": [{...}]}
      return DestinationResponse(
        items: (json['items'] as List<dynamic>? ?? [])
            .map((e) => Destination.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } else {
      // Fallback: empty list
      return DestinationResponse(items: []);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "items": items.map((e) => e.toJson()).toList(),
    };
  }
}
