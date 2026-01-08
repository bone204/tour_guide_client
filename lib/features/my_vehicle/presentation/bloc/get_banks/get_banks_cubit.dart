import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/core/services/bank/domain/usecases/get_banks_use_case.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_banks/get_banks_state.dart';

class GetBanksCubit extends Cubit<GetBanksState> {
  final GetBanksUseCase _getBanksUseCase;

  GetBanksCubit(this._getBanksUseCase) : super(GetBanksInitial());

  Future<void> getBanks() async {
    try {
      emit(GetBanksLoading());
      final result = await _getBanksUseCase(NoParams());
      result.fold(
        (failure) => emit(GetBanksError(failure.message)),
        (banks) => emit(GetBanksLoaded(banks)),
      );
    } catch (e) {
      emit(GetBanksError(e.toString()));
    }
  }
}
