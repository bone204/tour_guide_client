import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/car_rental/data/models/car_search_request.dart';
import 'package:tour_guide_app/features/car_rental/domain/usecases/search_cars_use_case.dart';
import 'package:tour_guide_app/features/car_rental/presentation/bloc/search_car/search_car_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class SearchCarCubit extends Cubit<SearchCarState> {
  SearchCarCubit() : super(const SearchCarState());

  Future<void> searchCars(CarSearchRequest request) async {
    emit(state.copyWith(status: SearchCarStatus.loading));

    final result = await sl<SearchCarsUseCase>().call(request);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SearchCarStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (cars) =>
          emit(state.copyWith(status: SearchCarStatus.success, cars: cars)),
    );
  }
}
