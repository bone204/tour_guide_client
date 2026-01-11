import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/usecases/cancel_rental_bill_usecase.dart';
import 'cancel_rental_bill_state.dart';

class CancelRentalBillCubit extends Cubit<CancelRentalBillState> {
  final CancelRentalBillUseCase _useCase;

  CancelRentalBillCubit(this._useCase) : super(CancelRentalBillInitial());

  Future<void> cancelBill(int id) async {
    if (isClosed) return;
    emit(CancelRentalBillLoading());
    final result = await _useCase(id);
    if (isClosed) return;
    result.fold(
      (failure) {
        if (!isClosed) emit(CancelRentalBillFailure(failure.message));
      },
      (success) {
        if (!isClosed) emit(CancelRentalBillSuccess(success));
      },
    );
  }
}
