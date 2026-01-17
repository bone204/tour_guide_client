import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/bills/book_hotel/data/models/hotel_bill.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/pay_hotel_bill_usecase.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/update_hotel_bill_usecase.dart';

part 'hotel_payment_state.dart';

class HotelPaymentCubit extends Cubit<HotelPaymentState> {
  final PayHotelBillUseCase _payHotelBillUseCase;
  final UpdateHotelBillUseCase _updateHotelBillUseCase;

  HotelPaymentCubit({
    required PayHotelBillUseCase payHotelBillUseCase,
    required UpdateHotelBillUseCase updateHotelBillUseCase,
  }) : _payHotelBillUseCase = payHotelBillUseCase,
       _updateHotelBillUseCase = updateHotelBillUseCase,
       super(const HotelPaymentState());

  void init(HotelBill bill) {
    emit(
      state.copyWith(
        bill: bill,
        billId: bill.id,
        contactName: bill.contactName,
        contactPhone: bill.contactPhone,
        notes: bill.notes,
      ),
    );
  }

  void updateContactInfo(String name, String phone, String notes) {
    emit(state.copyWith(contactName: name, contactPhone: phone, notes: notes));
    _updateBill();
  }

  Future<void> _updateBill() async {
    if (state.billId == null) return;

    await _updateHotelBillUseCase(
      state.billId!,
      contactName: state.contactName,
      contactPhone: state.contactPhone,
      notes: state.notes,
    );
  }

  Future<void> pay(int billId) async {
    emit(state.copyWith(status: HotelPaymentStatus.loading));

    final result = await _payHotelBillUseCase(billId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HotelPaymentStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (bill) =>
          emit(state.copyWith(status: HotelPaymentStatus.success, bill: bill)),
    );
  }
}
