import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/create_hotel_bill_request.dart';
import 'package:tour_guide_app/features/hotel_booking/domain/repository/hotel_booking_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class CreateHotelBillUseCase
    extends UseCase<Either<Failure, int>, CreateHotelBillRequest> {
  final HotelBookingRepository _repository = sl<HotelBookingRepository>();

  @override
  Future<Either<Failure, int>> call(CreateHotelBillRequest params) {
    return _repository.createHotelBill(params);
  }
}
