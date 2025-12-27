import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';

abstract class RentalBillRepository {
  Future<Either<Failure, List<RentalBill>>> getMyBills({
    RentalBillStatus? status,
  });
  Future<Either<Failure, RentalBill>> getBillDetail(int id);
}
