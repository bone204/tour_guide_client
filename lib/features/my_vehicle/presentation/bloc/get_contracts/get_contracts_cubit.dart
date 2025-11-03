import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/repository/my_vehicle_repository.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_contracts/get_contracts_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetContractsCubit extends Cubit<GetContractsState> {
  final _repository = sl<MyVehicleRepository>();

  GetContractsCubit() : super(GetContractsInitial());

  Future<void> getContracts(int userId) async {
    emit(GetContractsLoading());

    final result = await _repository.getContracts(userId);

    result.fold(
      (failure) => emit(GetContractsFailure(errorMessage: failure.message)),
      (contractResponse) {
        if (contractResponse.items.isNotEmpty) {
          emit(GetContractsSuccess(contracts: contractResponse.items));
        } else {
          emit(GetContractsEmpty());
        }
      },
    );
  }

  void reset() {
    emit(GetContractsInitial());
  }
}

