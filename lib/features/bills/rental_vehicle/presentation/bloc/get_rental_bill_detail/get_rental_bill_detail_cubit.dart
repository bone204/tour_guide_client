import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/usecases/get_rental_bill_detail_use_case.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/get_rental_bill_detail/rental_bill_detail_state.dart';

class GetRentalBillDetailCubit extends Cubit<RentalBillDetailState> {
  final GetRentalBillDetailUseCase _getRentalBillDetailUseCase;

  GetRentalBillDetailCubit(this._getRentalBillDetailUseCase)
    : super(const RentalBillDetailState());

  Future<void> getBillDetail(int id) async {
    if (isClosed) return;
    emit(state.copyWith(status: RentalBillDetailInitStatus.loading));

    final result = await _getRentalBillDetailUseCase(id);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RentalBillDetailInitStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (bill) => emit(
        state.copyWith(status: RentalBillDetailInitStatus.success, bill: bill),
      ),
    );
  }
}
