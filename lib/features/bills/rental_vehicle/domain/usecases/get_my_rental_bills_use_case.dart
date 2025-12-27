import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/repository/rental_bill_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetMyRentalBillsUseCase
    implements UseCase<Either<Failure, List<RentalBill>>, RentalBillStatus?> {
  @override
  Future<Either<Failure, List<RentalBill>>> call([RentalBillStatus? params]) {
    return sl<RentalBillRepository>().getMyBills(status: params);
  }
}
