import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/get_draft_itineraries.dart';

part 'get_draft_itineraries_state.dart';

class GetDraftItinerariesCubit extends Cubit<GetDraftItinerariesState> {
  final GetDraftItinerariesUseCase getDraftItinerariesUseCase;

  GetDraftItinerariesCubit(this.getDraftItinerariesUseCase)
    : super(GetDraftItinerariesInitial());

  Future<void> getDraftItineraries({String? province}) async {
    if (!isClosed) emit(GetDraftItinerariesLoading());
    final result = await getDraftItinerariesUseCase.call(province);
    result.fold(
      (failure) {
        if (!isClosed) emit(GetDraftItinerariesFailure(failure.message));
      },
      (response) {
        if (!isClosed) emit(GetDraftItinerariesSuccess(response.items));
      },
    );
  }

  @override
  void emit(GetDraftItinerariesState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
