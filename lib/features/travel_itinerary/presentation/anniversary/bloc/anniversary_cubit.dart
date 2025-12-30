import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/trigger_anniversary_check.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/anniversary/bloc/anniversary_state.dart';

class AnniversaryCubit extends Cubit<AnniversaryState> {
  final TriggerAnniversaryCheckUseCase _triggerAnniversaryCheckUseCase;

  AnniversaryCubit(this._triggerAnniversaryCheckUseCase)
    : super(AnniversaryInitial());

  Future<void> checkAnniversaries() async {
    emit(AnniversaryLoading());
    final result = await _triggerAnniversaryCheckUseCase(NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(AnniversaryFailure(failure.message)),
      (response) => emit(AnniversarySuccess(response)),
    );
  }
}
