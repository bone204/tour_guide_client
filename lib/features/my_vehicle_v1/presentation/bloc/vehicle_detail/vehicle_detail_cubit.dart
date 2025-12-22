import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/my_vehicle_v1/domain/usecases/get_vehicle_detail.dart';
import 'package:tour_guide_app/features/my_vehicle_v1/presentation/bloc/vehicle_detail/vehicle_detail_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class VehicleDetailCubit extends Cubit<VehicleDetailState> {
  final _getVehicleDetailUseCase = sl<GetVehicleDetailUseCase>();

  VehicleDetailCubit() : super(const VehicleDetailInitial());

  Future<void> fetchVehicle(String licensePlate) async {
    emit(const VehicleDetailLoading());
    final result = await _getVehicleDetailUseCase(licensePlate);
    result.fold(
      (failure) => emit(VehicleDetailFailure(failure.message)),
      (vehicle) => emit(VehicleDetailSuccess(vehicle)),
    );
  }
}

