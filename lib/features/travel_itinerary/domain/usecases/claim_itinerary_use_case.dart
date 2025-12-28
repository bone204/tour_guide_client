import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/claim_itinerary_request.dart';

class ClaimItineraryUseCase
    implements UseCase<Either<Failure, Itinerary>, ClaimItineraryRequest> {
  final ItineraryRepository repository;

  ClaimItineraryUseCase(this.repository);

  @override
  Future<Either<Failure, Itinerary>> call(ClaimItineraryRequest params) async {
    return await repository.claimItinerary(params);
  }
}
