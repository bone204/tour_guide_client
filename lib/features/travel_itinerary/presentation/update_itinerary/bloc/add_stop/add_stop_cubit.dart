import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/add_stop_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/add_stop.dart';

part 'add_stop_state.dart';

class AddStopCubit extends Cubit<AddStopState> {
  final AddStopUseCase addStopUseCase;

  AddStopCubit(this.addStopUseCase) : super(AddStopInitial());

  Future<void> addStop(int itineraryId, AddStopRequest request) async {
    emit(AddStopLoading());
    final result = await addStopUseCase.call(
      AddStopParams(itineraryId: itineraryId, request: request),
    );
    result.fold(
      (failure) => emit(AddStopFailure(failure.message)),
      (stop) => emit(AddStopSuccess(stop)),
    );
  }
}
