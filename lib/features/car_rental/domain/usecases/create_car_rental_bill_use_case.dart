import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/car_rental/data/models/create_car_rental_bill_request.dart';
import 'package:tour_guide_app/features/car_rental/domain/repository/car_rental_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class CreateCarRentalBillUseCase
    implements
        UseCase<Either<Failure, RentalBill>, CreateCarRentalBillRequest> {
  @override
  Future<Either<Failure, RentalBill>> call(
    CreateCarRentalBillRequest params,
  ) async {
    return await sl<CarRentalRepository>().createRentalBill(params);
  }
}
