import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/convert_address_models.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/convert_new_to_old_address_usecase.dart';

part 'convert_new_to_old_address_state.dart';

class ConvertNewToOldAddressCubit extends Cubit<ConvertNewToOldAddressState> {
  final ConvertNewToOldAddressUseCase _convertUseCase;

  ConvertNewToOldAddressCubit(this._convertUseCase)
    : super(const ConvertNewToOldAddressState());

  Future<void> convert(String address) async {
    if (isClosed) return;
    emit(state.copyWith(status: ConvertNewToOldAddressStatus.loading));

    final result = await _convertUseCase(ConvertAddressDto(address: address));

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ConvertNewToOldAddressStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(
          status: ConvertNewToOldAddressStatus.success,
          result: response,
        ),
      ),
    );
  }
}
