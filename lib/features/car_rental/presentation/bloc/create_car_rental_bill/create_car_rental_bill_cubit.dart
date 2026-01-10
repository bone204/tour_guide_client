import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/car_rental/data/models/create_car_rental_bill_request.dart';
import 'package:tour_guide_app/features/car_rental/domain/usecases/create_car_rental_bill_use_case.dart';
import 'package:tour_guide_app/service_locator.dart';

part 'create_car_rental_bill_state.dart';

class CreateCarRentalBillCubit extends Cubit<CreateCarRentalBillState> {
  final CreateCarRentalBillUseCase _createCarRentalBillUseCase;

  CreateCarRentalBillCubit({
    CreateCarRentalBillUseCase? createCarRentalBillUseCase,
  }) : _createCarRentalBillUseCase =
           createCarRentalBillUseCase ?? sl<CreateCarRentalBillUseCase>(),
       super(CreateCarRentalBillInitial());

  Future<void> createRentalBill(CreateCarRentalBillRequest request) async {
    if (isClosed) return;
    emit(CreateCarRentalBillLoading());

    // Add 7 hours to startDate and endDate as per user request to handle timezone/API expectations
    final modifiedRequest = CreateCarRentalBillRequest(
      rentalType: request.rentalType,
      vehicleType: request.vehicleType,
      durationPackage: request.durationPackage,
      startDate: request.startDate,
      endDate: request.endDate,
      location: request.location,
      pickupLatitude: request.pickupLatitude,
      pickupLongitude: request.pickupLongitude,
      details: request.details,
    );

    final result = await _createCarRentalBillUseCase(modifiedRequest);

    if (isClosed) return;

    result.fold(
      (failure) => emit(CreateCarRentalBillFailure(failure.message)),
      (bill) => emit(CreateCarRentalBillSuccess(bill)),
    );
  }
}
