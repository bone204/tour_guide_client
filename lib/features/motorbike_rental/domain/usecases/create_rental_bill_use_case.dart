import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/motorbike_rental/data/models/create_rental_bill_request.dart';
import 'package:tour_guide_app/features/motorbike_rental/domain/repository/motorbike_rental_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class CreateRentalBillUseCase
    implements UseCase<Either<Failure, RentalBill>, CreateRentalBillRequest> {
  @override
  Future<Either<Failure, RentalBill>> call(
    CreateRentalBillRequest params,
  ) async {
    return await sl<MotorbikeRentalRepository>().createRentalBill(params);
  }
}
