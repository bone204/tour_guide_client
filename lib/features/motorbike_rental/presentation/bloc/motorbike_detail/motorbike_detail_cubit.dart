import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/motorbike_rental/domain/usecases/get_motorbike_detail_use_case.dart';
import 'package:tour_guide_app/features/motorbike_rental/presentation/bloc/motorbike_detail/motorbike_detail_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class MotorbikeDetailCubit extends Cubit<MotorbikeDetailState> {
  MotorbikeDetailCubit() : super(const MotorbikeDetailState());

  Future<void> getMotorbikeDetail(String licensePlate) async {
    emit(state.copyWith(status: MotorbikeDetailStatus.loading));

    final result = await sl<GetMotorbikeDetailUseCase>().call(licensePlate);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MotorbikeDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (vehicle) => emit(
        state.copyWith(status: MotorbikeDetailStatus.success, vehicle: vehicle),
      ),
    );
  }
}
