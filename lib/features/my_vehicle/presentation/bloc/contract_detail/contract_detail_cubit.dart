import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/get_my_contract_detail.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/contract_detail/contract_detail_state.dart';

class ContractDetailCubit extends Cubit<ContractDetailState> {
  final GetMyContractDetailUseCase getMyContractDetailUseCase;

  ContractDetailCubit({required this.getMyContractDetailUseCase})
    : super(const ContractDetailState());

  Future<void> getContractDetail(int id) async {
    emit(state.copyWith(status: ContractDetailStatus.loading));

    final result = await getMyContractDetailUseCase(id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ContractDetailStatus.error,
          message: failure.message,
        ),
      ),
      (contract) => emit(
        state.copyWith(status: ContractDetailStatus.loaded, contract: contract),
      ),
    );
  }
}
