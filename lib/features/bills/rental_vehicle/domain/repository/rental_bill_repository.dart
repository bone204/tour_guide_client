import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/usecases/update_rental_bill_use_case.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill_pay_response.dart';

abstract class RentalBillRepository {
  Future<Either<Failure, List<RentalBill>>> getMyBills({
    RentalBillStatus? status,
  });
  Future<Either<Failure, RentalBill>> getBillDetail(int id);
  Future<Either<Failure, RentalBill>> updateBill(UpdateRentalBillParams params);
  Future<Either<Failure, RentalBillPayResponse>> payBill(int id);
}
