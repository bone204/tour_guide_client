import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/checkin_stop_response.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';

class CheckInStopUseCase {
  final ItineraryRepository repository;

  CheckInStopUseCase(this.repository);

  Future<Either<Failure, CheckInStopResponse>> call({
    required int itineraryId,
    required int stopId,
    required double latitude,
    required double longitude,
    int? toleranceMeters,
  }) {
    return repository.checkInStop(
      itineraryId,
      stopId,
      latitude,
      longitude,
      toleranceMeters,
    );
  }
}
