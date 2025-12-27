import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill_pay_response.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/repository/rental_bill_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class PayRentalBillUseCase
    implements UseCase<Either<Failure, RentalBillPayResponse>, int> {
  @override
  Future<Either<Failure, RentalBillPayResponse>> call(int id) {
    return sl<RentalBillRepository>().payBill(id);
  }
}
