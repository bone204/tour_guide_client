import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/trigger_anniversary_check.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/get_anniversary.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/anniversary/bloc/anniversary_state.dart';

class AnniversaryCubit extends Cubit<AnniversaryState> {
  final TriggerAnniversaryCheckUseCase _triggerAnniversaryCheckUseCase;
  final GetAnniversaryUseCase _getAnniversaryUseCase;

  AnniversaryCubit(
    this._triggerAnniversaryCheckUseCase,
    this._getAnniversaryUseCase,
  ) : super(AnniversaryInitial());

  Future<void> checkAnniversaries() async {
    emit(AnniversaryLoading());
    final result = await _triggerAnniversaryCheckUseCase(NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(AnniversaryFailure(failure.message)),
      (response) => emit(AnniversarySuccess(response)),
    );
  }

  Future<void> getAnniversaryDetail(int routeId) async {
    emit(AnniversaryLoading());
    final result = await _getAnniversaryUseCase(routeId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(AnniversaryFailure(failure.message)),
      (detail) => emit(AnniversaryDetailLoaded(detail)),
    );
  }
}
