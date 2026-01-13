import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/legacy_location_models.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/get_legacy_provinces_usecase.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/get_legacy_districts_of_province_usecase.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/get_legacy_wards_of_district_usecase.dart';

part 'legacy_locations_state.dart';

class LegacyLocationsCubit extends Cubit<LegacyLocationsState> {
  final GetLegacyProvincesUseCase _getProvincesUseCase;
  final GetLegacyDistrictsOfProvinceUseCase _getDistrictsUseCase;
  final GetLegacyWardsOfDistrictUseCase _getWardsUseCase;

  LegacyLocationsCubit({
    required GetLegacyProvincesUseCase getProvincesUseCase,
    required GetLegacyDistrictsOfProvinceUseCase getDistrictsUseCase,
    required GetLegacyWardsOfDistrictUseCase getWardsUseCase,
  }) : _getProvincesUseCase = getProvincesUseCase,
       _getDistrictsUseCase = getDistrictsUseCase,
       _getWardsUseCase = getWardsUseCase,
       super(const LegacyLocationsState());

  Future<void> getProvinces([String? search]) async {
    if (isClosed) return;
    emit(state.copyWith(status: LegacyLocationsStatus.loading));

    final result = await _getProvincesUseCase(search);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LegacyLocationsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (provinces) => emit(
        state.copyWith(
          status: LegacyLocationsStatus.success,
          provinces: provinces,
        ),
      ),
    );
  }

  Future<void> getDistricts(String provinceCode) async {
    if (isClosed) return;
    emit(state.copyWith(status: LegacyLocationsStatus.loading));

    final result = await _getDistrictsUseCase(provinceCode);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LegacyLocationsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (districts) => emit(
        state.copyWith(
          status: LegacyLocationsStatus.success,
          districts: districts,
        ),
      ),
    );
  }

  Future<void> getWards(String districtCode) async {
    if (isClosed) return;
    emit(state.copyWith(status: LegacyLocationsStatus.loading));

    final result = await _getWardsUseCase(districtCode);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LegacyLocationsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (wards) => emit(
        state.copyWith(status: LegacyLocationsStatus.success, wards: wards),
      ),
    );
  }

  void selectProvince(LegacyProvince? province) {
    emit(
      LegacyLocationsState(
        status: state.status,
        provinces: state.provinces,
        selectedProvince: province,
        // Explicitly clear dependent fields
        districts: const [],
        wards: const [],
        selectedDistrict: null,
        selectedWard: null,
      ),
    );
    if (province != null) {
      getDistricts(province.code);
    }
  }

  void selectDistrict(LegacyDistrict? district) {
    emit(
      LegacyLocationsState(
        status: state.status,
        provinces: state.provinces,
        districts: state.districts,
        selectedProvince: state.selectedProvince,
        selectedDistrict: district,
        // Explicitly clear dependent fields
        wards: const [],
        selectedWard: null,
      ),
    );
    if (district != null) {
      getWards(district.code);
    }
  }

  void selectWard(LegacyWard? ward) {
    emit(state.copyWith(selectedWard: ward));
  }
}
