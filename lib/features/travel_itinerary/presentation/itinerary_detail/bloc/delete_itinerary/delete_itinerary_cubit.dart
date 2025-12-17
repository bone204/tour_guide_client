import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/delete_itinerary.dart';
import 'package:tour_guide_app/core/events/app_events.dart';

part 'delete_itinerary_state.dart';

class DeleteItineraryCubit extends Cubit<DeleteItineraryState> {
  final DeleteItineraryUseCase deleteItineraryUseCase;

  DeleteItineraryCubit(this.deleteItineraryUseCase)
    : super(DeleteItineraryInitial());

  Future<void> deleteItinerary(int id) async {
    emit(DeleteItineraryLoading());
    final result = await deleteItineraryUseCase.call(id);
    result.fold((failure) => emit(DeleteItineraryFailure(failure.message)), (
      _,
    ) {
      eventBus.fire(ItineraryDeletedEvent());
      emit(DeleteItinerarySuccess());
    });
  }
}
