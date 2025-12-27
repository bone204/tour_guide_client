import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract_params.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/repository/my_vehicle_repository.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/create_contract/create_contract_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class CreateContractCubit extends Cubit<CreateContractState> {
  final _repository = sl<MyVehicleRepository>();

  CreateContractCubit() : super(CreateContractInitial());

  Future<void> createContract(ContractParams contractParams) async {
    emit(CreateContractLoading());

    // Using addContract instead of registerRentalVehicle as per my_vehicle repository definition
    final result = await _repository.addContract(contractParams);

    if (isClosed) return;

    result.fold(
      (failure) => emit(CreateContractFailure(errorMessage: failure.message)),
      (response) {
        emit(CreateContractSuccess(message: response.message));
        // Fire event to refresh My Vehicle page
        eventBus.fire(ContractRegisteredEvent());
      },
    );
  }

  void reset() {
    emit(CreateContractInitial());
  }
}
