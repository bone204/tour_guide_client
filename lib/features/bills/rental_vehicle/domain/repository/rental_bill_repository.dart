import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/usecases/update_rental_bill_use_case.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill_pay_response.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/confirm_qr_payment_request.dart';

abstract class RentalBillRepository {
  Future<Either<Failure, List<RentalBill>>> getMyBills({
    RentalBillStatus? status,
  });
  Future<Either<Failure, RentalBill>> getBillDetail(int id);
  Future<Either<Failure, RentalBill>> updateBill(UpdateRentalBillParams params);
  Future<Either<Failure, RentalBillPayResponse>> payBill(int id);
  Future<Either<Failure, SuccessResponse>> confirmQrPayment(
    ConfirmQrPaymentRequest params,
  );

  // Workflow
  Future<Either<Failure, SuccessResponse>> userPickup(int id, File selfie);
  Future<Either<Failure, SuccessResponse>> userReturnRequest(
    int id,
    List<File> photos,
    double latitude,
    double longitude,
  );
}
