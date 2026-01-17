import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/bills/book_hotel/data/models/hotel_bill.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/get_hotel_bill_detail_usecase.dart';

part 'hotel_bill_detail_state.dart';

class GetHotelBillDetailCubit extends Cubit<HotelBillDetailState> {
  final GetHotelBillDetailUseCase _getHotelBillDetailUseCase;

  GetHotelBillDetailCubit(this._getHotelBillDetailUseCase)
    : super(const HotelBillDetailState());

  Future<void> getBillDetail(int id) async {
    if (isClosed) return;
    emit(state.copyWith(status: HotelBillDetailInitStatus.loading));

    final result = await _getHotelBillDetailUseCase(id);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HotelBillDetailInitStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (bill) => emit(
        state.copyWith(status: HotelBillDetailInitStatus.success, bill: bill),
      ),
    );
  }

  Future<void> refreshBillDetail(int id) async {
    if (isClosed) return;
    // Do not emit loading state to avoid shimmering
    final result = await _getHotelBillDetailUseCase(id);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HotelBillDetailInitStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (bill) => emit(
        state.copyWith(status: HotelBillDetailInitStatus.success, bill: bill),
      ),
    );
  }
}
