import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/use_itinerary_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class UseItineraryParams {
  final int itineraryId;
  final UseItineraryRequest request;

  UseItineraryParams({required this.itineraryId, required this.request});
}

class UseItineraryUseCase
    implements UseCase<Either<Failure, SuccessResponse>, UseItineraryParams> {
  @override
  Future<Either<Failure, SuccessResponse>> call(
    UseItineraryParams params,
  ) async {
    return await sl<ItineraryRepository>().useItinerary(
      params.itineraryId,
      params.request,
    );
  }
}
