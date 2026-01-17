import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/bills/book_hotel/data/models/hotel_bill.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/get_my_hotel_bills_usecase.dart';

part 'get_my_hotel_bills_state.dart';

class GetMyHotelBillsCubit extends Cubit<GetMyHotelBillsState> {
  final GetMyHotelBillsUseCase getMyHotelBillsUseCase;

  GetMyHotelBillsCubit(this.getMyHotelBillsUseCase)
    : super(GetMyHotelBillsInitial());

  Future<void> getMyBills({HotelBillStatus? status}) async {
    if (isClosed) return;
    emit(GetMyHotelBillsLoading());
    final result = await getMyHotelBillsUseCase(status: status);
    if (isClosed) return;
    result.fold(
      (failure) => emit(GetMyHotelBillsFailure(_mapFailureToMessage(failure))),
      (bills) => emit(GetMyHotelBillsSuccess(bills)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return "Unexpected Error";
  }
}
