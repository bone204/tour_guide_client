import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';

class CheckInStopResponse {
  final bool matched;
  final double distanceMeters;
  final Stop stop;

  const CheckInStopResponse({
    required this.matched,
    required this.distanceMeters,
    required this.stop,
  });

  factory CheckInStopResponse.fromJson(Map<String, dynamic> json) {
    return CheckInStopResponse(
      matched: json['matched'] as bool,
      distanceMeters: (json['distanceMeters'] as num).toDouble(),
      stop: Stop.fromJson(json['stop'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matched': matched,
      'distanceMeters': distanceMeters,
      'stop': stop.toJson(),
    };
  }
}
