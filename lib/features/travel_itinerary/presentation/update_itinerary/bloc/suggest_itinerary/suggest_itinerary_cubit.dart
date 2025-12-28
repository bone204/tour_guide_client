import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/suggest_params.dart';
import 'package:tour_guide_app/core/utils/string_utils.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/suggest_itinerary.dart';
import 'suggest_itinerary_state.dart';

class SuggestItineraryCubit extends Cubit<SuggestItineraryState> {
  final SuggestItineraryUseCase _suggestItineraryUseCase;

  SuggestItineraryCubit(this._suggestItineraryUseCase)
    : super(const SuggestItineraryState());

  Future<void> suggestItinerary({
    required String province,
    required String startDate,
    required String endDate,
  }) async {
    emit(state.copyWith(status: SuggestItineraryStatus.loading));

    final result = await _suggestItineraryUseCase(
      SuggestParams(
        province: removeVietnameseAccents(province),
        startDate: startDate,
        endDate: endDate,
      ),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SuggestItineraryStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (itinerary) => emit(
        state.copyWith(
          status: SuggestItineraryStatus.success,
          suggestedItinerary: itinerary,
        ),
      ),
    );
  }
}
