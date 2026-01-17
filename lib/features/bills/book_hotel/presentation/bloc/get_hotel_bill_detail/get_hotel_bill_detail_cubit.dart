import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/bills/book_hotel/data/models/hotel_bill.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/get_hotel_bill_detail_usecase.dart';

part 'get_hotel_bill_detail_state.dart';

class GetHotelBillDetailCubit extends Cubit<GetHotelBillDetailState> {
  final GetHotelBillDetailUseCase getHotelBillDetailUseCase;

  GetHotelBillDetailCubit(this.getHotelBillDetailUseCase)
    : super(GetHotelBillDetailInitial());

  Future<void> getBillDetail(int id) async {
    if (isClosed) return;
    emit(GetHotelBillDetailLoading());
    final result = await getHotelBillDetailUseCase(id);
    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(GetHotelBillDetailFailure(_mapFailureToMessage(failure))),
      (bill) => emit(GetHotelBillDetailSuccess(bill)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return "Unexpected Error";
  }
}
