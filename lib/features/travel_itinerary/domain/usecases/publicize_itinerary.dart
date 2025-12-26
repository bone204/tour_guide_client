import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';

class PublicizeItineraryUseCase
    implements UseCase<Either<Failure, Itinerary>, PublicizeItineraryParams> {
  final ItineraryRepository repository;

  PublicizeItineraryUseCase(this.repository);

  @override
  Future<Either<Failure, Itinerary>> call(
    PublicizeItineraryParams params,
  ) async {
    return await repository.publicizeItinerary(params.itineraryId);
  }
}

class PublicizeItineraryParams extends Equatable {
  final int itineraryId;

  const PublicizeItineraryParams({required this.itineraryId});

  @override
  List<Object?> get props => [itineraryId];
}
