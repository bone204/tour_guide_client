import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/create_hotel_bill_request.dart';
import 'package:tour_guide_app/features/hotel_booking/domain/usecases/create_hotel_bill_usecase.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/bloc/create_hotel_bill/create_hotel_bill_state.dart';

class CreateHotelBillCubit extends Cubit<CreateHotelBillState> {
  final CreateHotelBillUseCase _createHotelBillUseCase;

  CreateHotelBillCubit(this._createHotelBillUseCase)
    : super(CreateHotelBillInitial());

  Future<void> createHotelBill(CreateHotelBillRequest request) async {
    if (isClosed) return;
    emit(CreateHotelBillLoading());
    final result = await _createHotelBillUseCase(request);
    if (isClosed) return;
    result.fold(
      (failure) {
        if (!isClosed) emit(CreateHotelBillFailure(failure.message));
      },
      (billId) {
        if (!isClosed) emit(CreateHotelBillSuccess(billId));
      },
    );
  }
}
