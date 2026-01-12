import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/claim_itinerary_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/create_itinerary_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/suggest_params.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/claim_itinerary_use_case.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/suggest_itinerary.dart';
import 'suggest_itinerary_state.dart';

class SuggestItineraryCubit extends Cubit<SuggestItineraryState> {
  final SuggestItineraryUseCase _suggestItineraryUseCase;
  final ClaimItineraryUseCase _claimItineraryUseCase;

  SuggestItineraryCubit(
    this._suggestItineraryUseCase,
    this._claimItineraryUseCase,
  ) : super(const SuggestItineraryState());

  Future<void> suggestItinerary({
    required String province,
    required String startDate,
    required String endDate,
  }) async {
    emit(state.copyWith(status: SuggestItineraryStatus.loading));

    final result = await _suggestItineraryUseCase(
      SuggestParams(province: province, startDate: startDate, endDate: endDate),
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

  Future<void> claimItinerary(Itinerary itinerary) async {
    emit(state.copyWith(claimStatus: ClaimStatus.loading));

    final request = ClaimItineraryRequest(
      name: itinerary.name,
      province: itinerary.province,
      startDate: itinerary.startDate,
      endDate: itinerary.endDate,
      stops:
          itinerary.stops
              .map(
                (s) => RouteStopRequest(
                  dayOrder: s.dayOrder,
                  sequence: s.sequence,
                  destinationId: s.destination?.id,
                  travelPoints: s.travelPoints,
                  startTime: s.startTime,
                  endTime: s.endTime,
                  notes: s.notes,
                ),
              )
              .toList(),
    );

    final result = await _claimItineraryUseCase(request);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          claimStatus: ClaimStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (itinerary) => emit(
        state.copyWith(
          claimStatus: ClaimStatus.success,
          claimedItinerary: itinerary,
        ),
      ),
    );
  }
}
