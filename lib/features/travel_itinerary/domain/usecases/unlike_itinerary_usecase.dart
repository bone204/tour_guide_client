import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class UnlikeItineraryUseCase implements UseCase<Either<Failure, SuccessResponse>, int> {
  @override
  Future<Either<Failure, SuccessResponse>> call(int itineraryId) async {
    return await sl<ItineraryRepository>().unlikeItinerary(itineraryId);
  }
}
