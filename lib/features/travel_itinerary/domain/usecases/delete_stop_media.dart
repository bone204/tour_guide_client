import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class DeleteStopMediaUseCase {
  final _repository = sl<ItineraryRepository>();

  Future<Either<Failure, Stop>> call({
    required int itineraryId,
    required int stopId,
    List<String> images = const [],
    List<String> videos = const [],
  }) {
    return _repository.deleteStopMedia(itineraryId, stopId, images, videos);
  }
}
