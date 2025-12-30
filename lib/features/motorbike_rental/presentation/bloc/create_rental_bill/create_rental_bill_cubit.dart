import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/motorbike_rental/data/models/create_rental_bill_request.dart';
import 'package:tour_guide_app/features/motorbike_rental/domain/usecases/create_rental_bill_use_case.dart';
import 'package:tour_guide_app/service_locator.dart';

part 'create_rental_bill_state.dart';

class CreateRentalBillCubit extends Cubit<CreateRentalBillState> {
  final CreateRentalBillUseCase _createRentalBillUseCase;

  CreateRentalBillCubit({CreateRentalBillUseCase? createRentalBillUseCase})
    : _createRentalBillUseCase =
          createRentalBillUseCase ?? sl<CreateRentalBillUseCase>(),
      super(CreateRentalBillInitial());

  Future<void> createRentalBill(CreateRentalBillRequest request) async {
    if (isClosed) return;
    emit(CreateRentalBillLoading());

    // Add 7 hours to startDate and endDate as per user request to handle timezone/API expectations
    final modifiedRequest = CreateRentalBillRequest(
      rentalType: request.rentalType,
      vehicleType: request.vehicleType,
      durationPackage: request.durationPackage,
      startDate: request.startDate,
      endDate: request.endDate,
      location: request.location,
      details: request.details,
    );

    final result = await _createRentalBillUseCase(modifiedRequest);

    if (isClosed) return;

    result.fold(
      (failure) => emit(CreateRentalBillFailure(failure.message)),
      (bill) => emit(CreateRentalBillSuccess(bill)),
    );
  }
}
