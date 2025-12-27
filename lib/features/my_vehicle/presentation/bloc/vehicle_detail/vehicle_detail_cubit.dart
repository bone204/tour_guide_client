import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/get_vehicle_detail.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/vehicle_detail/vehicle_detail_state.dart';

class VehicleDetailCubit extends Cubit<VehicleDetailState> {
  final GetVehicleDetailUseCase _getVehicleDetailUseCase;

  VehicleDetailCubit({required GetVehicleDetailUseCase getVehicleDetailUseCase})
    : _getVehicleDetailUseCase = getVehicleDetailUseCase,
      super(const VehicleDetailState());

  Future<void> getVehicleDetail(String licensePlate) async {
    emit(state.copyWith(status: VehicleDetailStatus.loading));

    final result = await _getVehicleDetailUseCase(licensePlate);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: VehicleDetailStatus.error,
          message: failure.message,
        ),
      ),
      (vehicle) => emit(
        state.copyWith(status: VehicleDetailStatus.success, vehicle: vehicle),
      ),
    );
  }
}
