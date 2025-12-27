import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/get_my_vehicles.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_my_vehicles/get_my_vehicles_state.dart';

class GetMyVehiclesCubit extends Cubit<GetMyVehiclesState> {
  final GetMyVehiclesUseCase _getMyVehiclesUseCase;

  GetMyVehiclesCubit(this._getMyVehiclesUseCase)
    : super(const GetMyVehiclesState());

  Future<void> getMyVehicles({String? status}) async {
    emit(state.copyWith(status: GetMyVehiclesStatus.loading));

    final result = await _getMyVehiclesUseCase(status);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: GetMyVehiclesStatus.error,
          message: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: GetMyVehiclesStatus.loaded,
          vehicles: data.items,
        ),
      ),
    );
  }
}
