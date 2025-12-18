import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/edit_stop_time_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class EditStopTimeUseCase
    implements UseCase<Either<Failure, Stop>, EditStopTimeParams> {
  final ItineraryRepository _repository = sl<ItineraryRepository>();

  @override
  Future<Either<Failure, Stop>> call(EditStopTimeParams params) async {
    return await _repository.editStopTime(
      params.itineraryId,
      params.stopId,
      params.request,
    );
  }
}

class EditStopTimeParams extends Equatable {
  final int itineraryId;
  final int stopId;
  final EditStopTimeRequest request;

  const EditStopTimeParams({
    required this.itineraryId,
    required this.stopId,
    required this.request,
  });

  @override
  List<Object> get props => [itineraryId, stopId, request];
}
