import 'package:tour_guide_app/features/my_vehicle_v1/data/models/contract.dart';

class ContractResponse {
  final List<Contract> items;

  ContractResponse({
    required this.items,
  });

  factory ContractResponse.fromJson(dynamic json) {
    // Handle both array and object response
    if (json is List) {
      // API trả về array trực tiếp: [{...}, {...}]
      return ContractResponse(
        items: json
            .map((e) => Contract.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } else if (json is Map<String, dynamic>) {
      // API trả về object với field items hoặc data: {"items": [{...}]} hoặc {"data": [{...}]}
      final List<dynamic> dataList = json['items'] as List<dynamic>? ?? 
                                      json['data'] as List<dynamic>? ?? [];
      return ContractResponse(
        items: dataList
            .map((e) => Contract.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } else {
      // Fallback: empty list
      return ContractResponse(items: []);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "items": items.map((e) => e.toJson()).toList(),
    };
  }
}
