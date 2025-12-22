import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/get_my_contracts.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_contracts/get_contracts_state.dart';

class GetContractsCubit extends Cubit<GetContractsState> {
  final GetMyContractsUseCase _getContractsUseCase;

  GetContractsCubit(this._getContractsUseCase)
    : super(const GetContractsState());

  Future<void> getContracts() async {
    emit(state.copyWith(status: GetContractsStatus.loading));
    final result = await _getContractsUseCase(null);
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: GetContractsStatus.error,
          message: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(
          status: GetContractsStatus.loaded,
          contracts: response.items,
        ),
      ),
    );
  }
}
