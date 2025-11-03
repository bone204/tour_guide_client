import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract_params.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/repository/my_vehicle_repository.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/register_rental_vehicle/register_rental_vehicle_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class RegisterRentalVehicleCubit extends Cubit<RegisterRentalVehicleState> {
  final _repository = sl<MyVehicleRepository>();

  RegisterRentalVehicleCubit() : super(RegisterRentalVehicleInitial());

  Future<void> registerRentalVehicle(ContractParams contractParams) async {
    emit(RegisterRentalVehicleLoading());

    final result = await _repository.registerRentalVehicle(contractParams);

    result.fold(
      (failure) => emit(RegisterRentalVehicleFailure(errorMessage: failure.message)),
      (response) => emit(RegisterRentalVehicleSuccess(message: response.message)),
    );
  }

  void reset() {
    emit(RegisterRentalVehicleInitial());
  }
}

