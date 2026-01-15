import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/update_travel_route_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/update_travel_route_use_case.dart';

part 'update_itinerary_name_state.dart';

class UpdateItineraryNameCubit extends Cubit<UpdateItineraryNameState> {
  final UpdateTravelRouteUseCase updateItineraryNameUseCase;

  UpdateItineraryNameCubit({required this.updateItineraryNameUseCase})
    : super(UpdateItineraryNameInitial());

  Future<void> updateItineraryName({
    required int id,
    required String name,
  }) async {
    if (isClosed) return;
    emit(UpdateItineraryNameLoading());

    final request = UpdateTravelRouteRequest(name: name);
    final result = await updateItineraryNameUseCase(
      UpdateTravelRouteParams(id: id, request: request),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(UpdateItineraryNameFailure(failure.message)),
      (itinerary) => emit(UpdateItineraryNameSuccess(itinerary)),
    );
  }
}
