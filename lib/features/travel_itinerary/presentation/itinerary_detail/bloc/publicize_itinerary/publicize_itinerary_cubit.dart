import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/publicize_itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/publicize_itinerary/publicize_itinerary_state.dart';

class PublicizeItineraryCubit extends Cubit<PublicizeItineraryState> {
  final PublicizeItineraryUseCase _publicizeItineraryUseCase;

  PublicizeItineraryCubit(this._publicizeItineraryUseCase)
    : super(PublicizeItineraryInitial());

  Future<void> publicize(int itineraryId) async {
    if (isClosed) return;
    emit(PublicizeItineraryLoading());

    final result = await _publicizeItineraryUseCase(
      PublicizeItineraryParams(itineraryId: itineraryId),
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(PublicizeItineraryFailure(failure.message));
        }
      },
      (itinerary) {
        if (!isClosed) {
          emit(PublicizeItinerarySuccess(itinerary));
        }
      },
    );
  }

  @override
  void emit(PublicizeItineraryState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
