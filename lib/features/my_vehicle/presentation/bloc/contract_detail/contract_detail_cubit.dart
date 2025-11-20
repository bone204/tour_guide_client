import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/get_contract_detail.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/contract_detail/contract_detail_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class ContractDetailCubit extends Cubit<ContractDetailState> {
  final _getContractDetailUseCase = sl<GetContractDetailUseCase>();

  ContractDetailCubit() : super(const ContractDetailInitial());

  Future<void> fetchContract(int id) async {
    emit(const ContractDetailLoading());
    final result = await _getContractDetailUseCase(id);
    result.fold(
      (failure) => emit(ContractDetailFailure(failure.message)),
      (contract) => emit(ContractDetailSuccess(contract)),
    );
  }
}

