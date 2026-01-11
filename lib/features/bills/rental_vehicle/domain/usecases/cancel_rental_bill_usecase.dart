import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/repository/rental_bill_repository.dart';

class CancelRentalBillUseCase {
  final RentalBillRepository repository;

  CancelRentalBillUseCase(this.repository);

  Future<Either<Failure, SuccessResponse>> call(int id) {
    return repository.cancelBill(id);
  }
}
