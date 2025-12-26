import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetDraftItinerariesUseCase
    implements UseCase<Either<Failure, ItineraryResponse>, String?> {
  @override
  Future<Either<Failure, ItineraryResponse>> call(String? province) async {
    return await sl<ItineraryRepository>().getDraftItineraries(province);
  }
}
