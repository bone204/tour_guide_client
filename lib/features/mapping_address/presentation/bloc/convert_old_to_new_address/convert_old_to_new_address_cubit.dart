import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/mapping_address/data/models/convert_address_models.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/convert_old_to_new_address_usecase.dart';

part 'convert_old_to_new_address_state.dart';

class ConvertOldToNewAddressCubit extends Cubit<ConvertOldToNewAddressState> {
  final ConvertOldToNewAddressUseCase _convertUseCase;

  ConvertOldToNewAddressCubit(this._convertUseCase)
    : super(const ConvertOldToNewAddressState());

  Future<void> convert(String address) async {
    if (isClosed) return;
    emit(state.copyWith(status: ConvertOldToNewAddressStatus.loading));

    final result = await _convertUseCase(ConvertAddressDto(address: address));

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ConvertOldToNewAddressStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(
          status: ConvertOldToNewAddressStatus.success,
          result: response,
        ),
      ),
    );
  }
}
