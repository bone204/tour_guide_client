import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/suggest_params.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class SuggestItineraryUseCase implements UseCase<Either<Failure, Itinerary>, SuggestParams> {
  @override
  Future<Either<Failure, Itinerary>> call(SuggestParams params) async {
    return await sl<ItineraryRepository>().suggestItinerary(params);
  }
}
