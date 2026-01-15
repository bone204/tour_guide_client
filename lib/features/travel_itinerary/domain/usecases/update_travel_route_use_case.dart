import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/update_travel_route_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';

class UpdateTravelRouteUseCase
    implements UseCase<Either<Failure, Itinerary>, UpdateTravelRouteParams> {
  final ItineraryRepository repository;

  UpdateTravelRouteUseCase(this.repository);

  @override
  Future<Either<Failure, Itinerary>> call(
    UpdateTravelRouteParams params,
  ) async {
    return await repository.updateTravelRoute(params.id, params.request);
  }
}

class UpdateTravelRouteParams {
  final int id;
  final UpdateTravelRouteRequest request;

  UpdateTravelRouteParams({required this.id, required this.request});
}
