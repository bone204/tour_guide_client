import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/bills/book_hotel/data/models/hotel_bill.dart';
import 'package:tour_guide_app/features/bills/book_hotel/data/models/update_hotel_bill_request.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/cancel_hotel_bill_usecase.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/confirm_hotel_bill_usecase.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/update_hotel_bill_usecase.dart';

part 'book_hotel_workflow_state.dart';

class BookHotelWorkflowCubit extends Cubit<BookHotelWorkflowState> {
  final UpdateHotelBillUseCase updateHotelBillUseCase;
  final ConfirmHotelBillUseCase confirmHotelBillUseCase;
  final CancelHotelBillUseCase cancelHotelBillUseCase;

  BookHotelWorkflowCubit({
    required this.updateHotelBillUseCase,
    required this.confirmHotelBillUseCase,
    required this.cancelHotelBillUseCase,
  }) : super(BookHotelWorkflowInitial());

  Future<void> update(
    int id, {
    String? contactName,
    String? contactPhone,
    String? notes,
    String? voucherCode,
    double? travelPointsUsed,
    String? paymentMethod,
  }) async {
    if (isClosed) return;
    emit(BookHotelWorkflowLoading());
    final result = await updateHotelBillUseCase(
      UpdateHotelBillRequest(
        id: id,
        contactName: contactName,
        contactPhone: contactPhone,
        notes: notes,
        voucherCode: voucherCode,
        travelPointsUsed: travelPointsUsed,
        paymentMethod: paymentMethod,
      ),
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
