import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/get_itinerary_detail.dart';

part 'get_itinerary_detail_state.dart';

class GetItineraryDetailCubit extends Cubit<GetItineraryDetailState> {
  final GetItineraryDetailUseCase getItineraryDetailUseCase;

  GetItineraryDetailCubit(this.getItineraryDetailUseCase)
    : super(GetItineraryDetailInitial());

  Future<void> getItineraryDetail(int id) async {
    emit(GetItineraryDetailLoading());
    final result = await getItineraryDetailUseCase.call(id);
    result.fold(
      (failure) => emit(GetItineraryDetailFailure(failure.message)),
      (itinerary) => emit(GetItineraryDetailSuccess(itinerary)),
    );
  }
}
