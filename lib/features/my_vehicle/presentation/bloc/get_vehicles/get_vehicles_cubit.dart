import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/repository/my_vehicle_repository.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_vehicles/get_vehicles_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetVehiclesCubit extends Cubit<GetVehiclesState> {
  final _repository = sl<MyVehicleRepository>();

  GetVehiclesCubit() : super(GetVehiclesInitial());

  Future<void> getVehicles(int contractId) async {
    emit(GetVehiclesLoading());

    final result = await _repository.getVehicles(contractId);

    result.fold(
      (failure) => emit(GetVehiclesFailure(errorMessage: failure.message)),
      (vehicleResponse) {
        if (vehicleResponse.items.isNotEmpty) {
          emit(GetVehiclesSuccess(vehicles: vehicleResponse.items));
        } else {
          emit(GetVehiclesEmpty());
        }
      },
    );
  }

  void reset() {
    emit(GetVehiclesInitial());
  }
}

