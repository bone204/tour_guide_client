import 'package:bloc/bloc.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/delete_itinerary_stop.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/delete_stop/delete_stop_state.dart';

class DeleteStopCubit extends Cubit<DeleteStopState> {
  final DeleteItineraryStopUseCase deleteItineraryStopUseCase;

  DeleteStopCubit(this.deleteItineraryStopUseCase) : super(DeleteStopInitial());

  Future<void> deleteStop(int itineraryId, int stopId) async {
    emit(DeleteStopLoading());

    final result = await deleteItineraryStopUseCase(
      DeleteItineraryStopParams(itineraryId: itineraryId, stopId: stopId),
    );

    result.fold(
      (failure) => emit(DeleteStopFailure(failure.message)),
      (_) => emit(DeleteStopSuccess()),
    );
  }
}
