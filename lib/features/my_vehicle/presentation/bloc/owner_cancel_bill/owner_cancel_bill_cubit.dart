import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/owner_cancel_bill.usecase.dart';
import 'owner_cancel_bill_state.dart';

class OwnerCancelBillCubit extends Cubit<OwnerCancelBillState> {
  final OwnerCancelBillUseCase _useCase;

  OwnerCancelBillCubit(this._useCase) : super(OwnerCancelBillInitial());

  Future<void> cancelBill(int id, String reason) async {
    if (isClosed) return;
    emit(OwnerCancelBillLoading());
    final result = await _useCase(id, reason);
    if (isClosed) return;
    result.fold(
      (failure) {
        if (!isClosed) emit(OwnerCancelBillFailure(failure.message));
      },
      (success) {
        if (!isClosed) emit(OwnerCancelBillSuccess(success));
      },
    );
  }
}
