import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';

class CloneItineraryUseCase
    implements UseCase<Either<Failure, Itinerary>, CloneItineraryParams> {
  final ItineraryRepository repository;

  CloneItineraryUseCase(this.repository);

  @override
  Future<Either<Failure, Itinerary>> call(CloneItineraryParams params) async {
    return await repository.cloneItinerary(params.itineraryId);
  }
}

class CloneItineraryParams extends Equatable {
  final int itineraryId;

  const CloneItineraryParams({required this.itineraryId});

  @override
  List<Object?> get props => [itineraryId];
}
