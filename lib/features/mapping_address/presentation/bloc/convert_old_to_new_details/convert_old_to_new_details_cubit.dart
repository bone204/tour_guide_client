import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/convert_details_models.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/convert_old_to_new_details_usecase.dart';

part 'convert_old_to_new_details_state.dart';

class ConvertOldToNewDetailsCubit extends Cubit<ConvertOldToNewDetailsState> {
  final ConvertOldToNewDetailsUseCase _convertUseCase;

  ConvertOldToNewDetailsCubit(this._convertUseCase)
    : super(const ConvertOldToNewDetailsState());

  Future<void> convert({
    required String province,
    required String district,
    required String ward,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(status: ConvertOldToNewDetailsStatus.loading));

    final result = await _convertUseCase(
      ConvertOldToNewDetailsDto(
        province: province,
        district: district,
        ward: ward,
      ),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ConvertOldToNewDetailsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(
          status: ConvertOldToNewDetailsStatus.success,
          result: response,
        ),
      ),
    );
  }
}
