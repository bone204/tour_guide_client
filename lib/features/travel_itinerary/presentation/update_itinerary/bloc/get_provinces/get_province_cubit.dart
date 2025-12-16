import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/province.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/get_provinces.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/get_provinces/get_province_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetProvinceCubit extends Cubit<GetProvinceState> {
  GetProvinceCubit() : super(GetProvinceInitial());

  Future<Either<Failure, ProvinceResponse>> getProvinces({
    required String? search,
  }) async {
    if (!isClosed) emit(GetProvinceLoading());
    final result = await sl<GetProvincesUseCase>().call(search);
    result.fold(
      (failure) {
        if (!isClosed) emit(GetProvinceError(failure.message));
      },
      (provinceResponse) {
        if (!isClosed) {
          emit(
            GetProvinceLoaded(provinces: provinceResponse.items, search: search),
          );
        }
      },
    );
    return result;
  }
}
