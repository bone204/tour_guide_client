import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';

class DeleteItineraryStopUseCase
    implements
        UseCase<Either<Failure, SuccessResponse>, DeleteItineraryStopParams> {
  final ItineraryRepository repository;

  DeleteItineraryStopUseCase(this.repository);

  @override
  Future<Either<Failure, SuccessResponse>> call(
    DeleteItineraryStopParams params,
  ) async {
    return await repository.deleteStop(params.itineraryId, params.stopId);
  }
}

class DeleteItineraryStopParams {
  final int itineraryId;
  final int stopId;

  DeleteItineraryStopParams({required this.itineraryId, required this.stopId});
}
