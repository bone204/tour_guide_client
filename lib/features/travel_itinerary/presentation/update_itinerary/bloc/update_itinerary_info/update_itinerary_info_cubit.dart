import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/update_travel_route_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/update_travel_route_use_case.dart';

part 'update_itinerary_info_state.dart';

class UpdateItineraryInfoCubit extends Cubit<UpdateItineraryInfoState> {
  final UpdateTravelRouteUseCase updateItineraryInfoUseCase;

  UpdateItineraryInfoCubit({required this.updateItineraryInfoUseCase})
    : super(UpdateItineraryInfoInitial());

  Future<void> updateItineraryInfo({
    required int id,
    String? name,
    String? startDate,
    String? endDate,
  }) async {
    if (isClosed) return;
    emit(UpdateItineraryInfoLoading());

    final request = UpdateTravelRouteRequest(
      name: name,
      startDate: startDate,
      endDate: endDate,
    );
    final result = await updateItineraryInfoUseCase(
      UpdateTravelRouteParams(id: id, request: request),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(UpdateItineraryInfoFailure(failure.message)),
      (itinerary) => emit(UpdateItineraryInfoSuccess(itinerary)),
    );
  }
}
