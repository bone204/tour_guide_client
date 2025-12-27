import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/disable_vehicle.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/enable_vehicle.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/enable_disable_vehicle/enable_disable_vehicle_state.dart';

class EnableDisableVehicleCubit extends Cubit<EnableDisableVehicleState> {
  final EnableVehicleUseCase _enableVehicleUseCase;
  final DisableVehicleUseCase _disableVehicleUseCase;

  EnableDisableVehicleCubit({
    required EnableVehicleUseCase enableVehicleUseCase,
    required DisableVehicleUseCase disableVehicleUseCase,
  }) : _enableVehicleUseCase = enableVehicleUseCase,
       _disableVehicleUseCase = disableVehicleUseCase,
       super(const EnableDisableVehicleState());

  Future<void> enableVehicle(String licensePlate) async {
    emit(state.copyWith(status: EnableDisableVehicleStatus.loading));

    final result = await _enableVehicleUseCase(licensePlate);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EnableDisableVehicleStatus.error,
          message: failure.message,
        ),
      ),
      (success) {
        emit(state.copyWith(status: EnableDisableVehicleStatus.success));
        eventBus.fire(VehicleStatusChangedEvent(licensePlate));
      },
    );
  }

  Future<void> disableVehicle(String licensePlate) async {
    emit(state.copyWith(status: EnableDisableVehicleStatus.loading));

    final result = await _disableVehicleUseCase(licensePlate);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EnableDisableVehicleStatus.error,
          message: failure.message,
        ),
      ),
      (success) {
        emit(state.copyWith(status: EnableDisableVehicleStatus.success));
        eventBus.fire(VehicleStatusChangedEvent(licensePlate));
      },
    );
  }
}
