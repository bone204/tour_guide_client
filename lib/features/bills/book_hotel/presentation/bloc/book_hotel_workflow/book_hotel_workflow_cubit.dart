import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/bills/book_hotel/data/models/hotel_bill.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/cancel_hotel_bill_usecase.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/confirm_hotel_bill_usecase.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/pay_hotel_bill_usecase.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/update_hotel_bill_usecase.dart';

part 'book_hotel_workflow_state.dart';

class BookHotelWorkflowCubit extends Cubit<BookHotelWorkflowState> {
  final ConfirmHotelBillUseCase confirmHotelBillUseCase;
  final PayHotelBillUseCase payHotelBillUseCase;
  final CancelHotelBillUseCase cancelHotelBillUseCase;
  final UpdateHotelBillUseCase updateHotelBillUseCase;

  BookHotelWorkflowCubit({
    required this.confirmHotelBillUseCase,
    required this.payHotelBillUseCase,
    required this.cancelHotelBillUseCase,
    required this.updateHotelBillUseCase,
  }) : super(BookHotelWorkflowInitial());

  Future<void> update(
    int id, {
    String? contactName,
    String? contactPhone,
    String? notes,
    String? voucherCode,
    double? travelPointsUsed,
  }) async {
    if (isClosed) return;
    emit(BookHotelWorkflowLoading());
    final result = await updateHotelBillUseCase(
      id,
      contactName: contactName,
      contactPhone: contactPhone,
      notes: notes,
      voucherCode: voucherCode,
      travelPointsUsed: travelPointsUsed,
    );
    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(BookHotelWorkflowFailure(_mapFailureToMessage(failure))),
      (bill) => emit(BookHotelWorkflowSuccess(bill)),
    );
  }

  Future<void> confirm(int id, String paymentMethod) async {
    if (isClosed) return;
    emit(BookHotelWorkflowLoading());
    final result = await confirmHotelBillUseCase(id, paymentMethod);
    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(BookHotelWorkflowFailure(_mapFailureToMessage(failure))),
      (bill) => emit(BookHotelWorkflowSuccess(bill)),
    );
  }

  Future<void> pay(int id) async {
    if (isClosed) return;
    emit(BookHotelWorkflowLoading());
    final result = await payHotelBillUseCase(id);
    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(BookHotelWorkflowFailure(_mapFailureToMessage(failure))),
      (bill) => emit(BookHotelWorkflowSuccess(bill)),
    );
  }

  Future<void> cancel(int id, {String? reason}) async {
    if (isClosed) return;
    emit(BookHotelWorkflowLoading());
    final result = await cancelHotelBillUseCase(
      CancelHotelBillParams(id: id, reason: reason),
    );
    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(BookHotelWorkflowFailure(_mapFailureToMessage(failure))),
      (bill) => emit(BookHotelWorkflowSuccess(bill)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return "Unexpected Error";
  }
}
