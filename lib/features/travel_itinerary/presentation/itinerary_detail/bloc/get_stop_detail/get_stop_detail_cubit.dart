import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/get_stop_detail.dart';

part 'get_stop_detail_state.dart';

class GetStopDetailCubit extends Cubit<GetStopDetailState> {
  final GetStopDetailUseCase getStopDetailUseCase;

  GetStopDetailCubit(this.getStopDetailUseCase) : super(GetStopDetailInitial());

  Future<void> getStopDetail(int itineraryId, int stopId) async {
    if (!isClosed) emit(GetStopDetailLoading());
    final result = await getStopDetailUseCase(
      GetStopDetailParams(itineraryId: itineraryId, stopId: stopId),
    );
    result.fold(
      (failure) {
        if (!isClosed) emit(GetStopDetailFailure(message: failure.message));
      },
      (stop) {
        if (!isClosed) emit(GetStopDetailSuccess(stop: stop));
      },
    );
  }
}
