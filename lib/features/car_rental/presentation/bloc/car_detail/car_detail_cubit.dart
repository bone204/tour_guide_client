import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/car_rental/domain/usecases/get_car_detail_use_case.dart';
import 'package:tour_guide_app/features/car_rental/presentation/bloc/car_detail/car_detail_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class CarDetailCubit extends Cubit<CarDetailState> {
  CarDetailCubit() : super(const CarDetailState());

  Future<void> getCarDetail(String licensePlate) async {
    emit(state.copyWith(status: CarDetailStatus.loading));

    final result = await sl<GetCarDetailUseCase>().call(licensePlate);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CarDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (vehicle) => emit(
        state.copyWith(status: CarDetailStatus.success, vehicle: vehicle),
      ),
    );
  }
}
