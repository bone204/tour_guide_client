import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/cancel_hotel_bill_usecase.dart';

part 'cancel_hotel_bill_state.dart';

class CancelHotelBillCubit extends Cubit<CancelHotelBillState> {
  final CancelHotelBillUseCase _cancelHotelBillUseCase;

  CancelHotelBillCubit(this._cancelHotelBillUseCase)
    : super(CancelHotelBillInitial());

  Future<void> cancelBill(int id, String reason) async {
    emit(CancelHotelBillLoading());

    final result = await _cancelHotelBillUseCase(
      CancelHotelBillParams(id: id, reason: reason),
    );

    result.fold(
      (failure) => emit(CancelHotelBillFailure(message: failure.message)),
      (_) => emit(CancelHotelBillSuccess()),
    );
  }
}
