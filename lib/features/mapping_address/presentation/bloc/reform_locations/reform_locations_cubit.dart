import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/reform_location_models.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/get_reform_provinces_usecase.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/get_reform_communes_of_province_usecase.dart';

part 'reform_locations_state.dart';

class ReformLocationsCubit extends Cubit<ReformLocationsState> {
  final GetReformProvincesUseCase _getProvincesUseCase;
  final GetReformCommunesOfProvinceUseCase _getCommunesUseCase;

  ReformLocationsCubit({
    required GetReformProvincesUseCase getProvincesUseCase,
    required GetReformCommunesOfProvinceUseCase getCommunesUseCase,
  }) : _getProvincesUseCase = getProvincesUseCase,
       _getCommunesUseCase = getCommunesUseCase,
       super(const ReformLocationsState());

  Future<void> getProvinces([String? search]) async {
    if (isClosed) return;
    emit(state.copyWith(status: ReformLocationsStatus.loading));

    final result = await _getProvincesUseCase(search);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ReformLocationsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (provinces) => emit(
        state.copyWith(
          status: ReformLocationsStatus.success,
          provinces: provinces,
        ),
      ),
    );
  }

  Future<void> getCommunes(String provinceCode) async {
    if (isClosed) return;
    emit(state.copyWith(status: ReformLocationsStatus.loading));

    final result = await _getCommunesUseCase(provinceCode);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ReformLocationsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (communes) => emit(
        state.copyWith(
          status: ReformLocationsStatus.success,
          communes: communes,
        ),
      ),
    );
  }

  void selectProvince(ReformProvince? province) {
    emit(
      ReformLocationsState(
        status: state.status,
        provinces: state.provinces,
        selectedProvince: province,
        // Explicitly clear dependent fields
        communes: const [],
        selectedCommune: null,
      ),
    );
    if (province != null) {
      getCommunes(province.code);
    }
  }

  void selectCommune(ReformCommune? commune) {
    emit(state.copyWith(selectedCommune: commune));
  }
}
