import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/checkin_stop_usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/checkin_stop/checkin_stop_state.dart';

class CheckInStopCubit extends Cubit<CheckInStopState> {
  final CheckInStopUseCase checkInStopUseCase;

  CheckInStopCubit(this.checkInStopUseCase) : super(CheckInStopInitial());

  Future<void> checkIn({
    required int itineraryId,
    required int stopId,
    required double latitude,
    required double longitude,
    int? toleranceMeters,
  }) async {
    emit(CheckInStopLoading());

    final result = await checkInStopUseCase(
      itineraryId: itineraryId,
      stopId: stopId,
      latitude: latitude,
      longitude: longitude,
      toleranceMeters: toleranceMeters,
    );

    result.fold(
      (failure) => emit(CheckInStopFailure(failure.message)),
      (response) => emit(CheckInStopSuccess(response)),
    );
  }
}
