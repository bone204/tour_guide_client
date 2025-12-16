import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/add_stop_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class AddStopUseCase implements UseCase<Either<Failure, Stop>, AddStopParams> {
  final ItineraryRepository _repository = sl<ItineraryRepository>();

  @override
  Future<Either<Failure, Stop>> call(AddStopParams params) async {
    return _repository.addStop(params.itineraryId, params.request);
  }
}

class AddStopParams extends Equatable {
  final int itineraryId;
  final AddStopRequest request;

  const AddStopParams({required this.itineraryId, required this.request});

  @override
  List<Object?> get props => [itineraryId, request];
}
