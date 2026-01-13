import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/convert_details_models.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/convert_new_to_old_details_usecase.dart';

part 'convert_new_to_old_details_state.dart';

class ConvertNewToOldDetailsCubit extends Cubit<ConvertNewToOldDetailsState> {
  final ConvertNewToOldDetailsUseCase _convertUseCase;

  ConvertNewToOldDetailsCubit(this._convertUseCase)
    : super(const ConvertNewToOldDetailsState());

  Future<void> convert({
    required String province,
    required String commune,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(status: ConvertNewToOldDetailsStatus.loading));

    final result = await _convertUseCase(
      ConvertNewToOldDetailsDto(province: province, commune: commune),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ConvertNewToOldDetailsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(
          status: ConvertNewToOldDetailsStatus.success,
          result: response,
        ),
      ),
    );
  }
}
