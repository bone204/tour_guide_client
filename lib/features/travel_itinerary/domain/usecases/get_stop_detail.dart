import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetStopDetailUseCase
    implements UseCase<Either<Failure, Stop>, GetStopDetailParams> {
  @override
  Future<Either<Failure, Stop>> call(GetStopDetailParams params) async {
    return await sl<ItineraryRepository>().getStopDetail(
      params.itineraryId,
      params.stopId,
    );
  }
}

class GetStopDetailParams extends Equatable {
  final int itineraryId;
  final int stopId;

  const GetStopDetailParams({required this.itineraryId, required this.stopId});

  @override
  List<Object?> get props => [itineraryId, stopId];
}
