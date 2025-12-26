import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/get_itinerary_detail.dart';
import 'itinerary_explore_detail_state.dart';

class ItineraryExploreDetailCubit extends Cubit<ItineraryExploreDetailState> {
  final GetItineraryDetailUseCase _getItineraryDetailUseCase;

  ItineraryExploreDetailCubit(this._getItineraryDetailUseCase)
    : super(ItineraryExploreDetailInitial());

  Future<void> getItineraryDetail(int id) async {
    emit(ItineraryExploreDetailLoading());
    final result = await _getItineraryDetailUseCase(id);
    result.fold(
      (failure) => emit(ItineraryExploreDetailFailure(failure.message)),
      (itinerary) => emit(ItineraryExploreDetailSuccess(itinerary)),
    );
  }
}
