import 'package:tour_guide_app/features/travel_itinerary/data/models/create_itinerary_request.dart';

class ClaimItineraryRequest {
  final String name;
  final String? province;
  final String? startDate;
  final String? endDate;
  final List<RouteStopRequest>? stops;

  const ClaimItineraryRequest({
    required this.name,
    this.province,
    this.startDate,
    this.endDate,
    this.stops,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (province != null) 'province': province,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
      if (stops != null) 'stops': stops!.map((s) => s.toJson()).toList(),
    };
  }
}
