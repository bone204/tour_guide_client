import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/use_itinerary_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/use_itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/use_itinerary/use_itinerary_state.dart';

class UseItineraryCubit extends Cubit<UseItineraryState> {
  final UseItineraryUseCase useItineraryUseCase;

  UseItineraryCubit(this.useItineraryUseCase) : super(UseItineraryInitial());

  Future<void> useItinerary(
    int itineraryId,
    UseItineraryRequest request,
  ) async {
    emit(UseItineraryLoading());
    final result = await useItineraryUseCase(
      UseItineraryParams(itineraryId: itineraryId, request: request),
    );
    result.fold(
      (failure) => emit(UseItineraryFailure(failure.message)),
      (response) => emit(UseItinerarySuccess(response)),
    );
  }

  @override
  void emit(UseItineraryState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
