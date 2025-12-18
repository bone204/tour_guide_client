import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/edit_stop_reorder_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class EditStopReorderUseCase
    implements UseCase<Either<Failure, Stop>, EditStopReorderParams> {
  final ItineraryRepository _repository = sl<ItineraryRepository>();

  @override
  Future<Either<Failure, Stop>> call(EditStopReorderParams params) async {
    return await _repository.editStopReorder(
      params.itineraryId,
      params.stopId,
      params.request,
    );
  }
}

class EditStopReorderParams extends Equatable {
  final int itineraryId;
  final int stopId;
  final EditStopReorderRequest request;

  const EditStopReorderParams({
    required this.itineraryId,
    required this.stopId,
    required this.request,
  });

  @override
  List<Object> get props => [itineraryId, stopId, request];
}
