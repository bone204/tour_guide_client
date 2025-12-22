import 'package:tour_guide_app/features/my_vehicle_v1/data/models/vehicle.dart';

class VehicleResponse {
  final List<Vehicle> items;

  VehicleResponse({
    required this.items,
  });

  factory VehicleResponse.fromJson(dynamic json) {
    // Handle both array and object response
    if (json is List) {
      // API trả về array trực tiếp: [{...}, {...}]
      return VehicleResponse(
        items: json
            .map((e) => Vehicle.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } else if (json is Map<String, dynamic>) {
      // API trả về object với field items hoặc data
      final List<dynamic> dataList = json['items'] as List<dynamic>? ?? 
                                      json['data'] as List<dynamic>? ?? [];
      return VehicleResponse(
        items: dataList
            .map((e) => Vehicle.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } else {
      // Fallback: empty list
      return VehicleResponse(items: []);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "items": items.map((e) => e.toJson()).toList(),
    };
  }
}

