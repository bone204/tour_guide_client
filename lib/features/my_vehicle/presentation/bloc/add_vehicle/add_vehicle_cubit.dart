import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle_rental_params.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/repository/my_vehicle_repository.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/add_vehicle/add_vehicle_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class AddVehicleCubit extends Cubit<AddVehicleState> {
  final _repository = sl<MyVehicleRepository>();

  AddVehicleCubit() : super(AddVehicleInitial());

  Future<void> addVehicle(VehicleRentalParams vehicle) async {
    emit(AddVehicleLoading());

    final result = await _repository.addVehicle(vehicle);

    result.fold(
      (failure) => emit(AddVehicleFailure(errorMessage: failure.message)),
      (response) => emit(AddVehicleSuccess(message: response.message)),
    );
  }

  void reset() {
    emit(AddVehicleInitial());
  }
}

