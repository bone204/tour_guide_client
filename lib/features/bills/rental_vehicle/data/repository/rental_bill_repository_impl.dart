import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/data_source/rental_bill_api_service.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/update_rental_bill_request.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/repository/rental_bill_repository.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/usecases/update_rental_bill_use_case.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill_pay_response.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/confirm_qr_payment_request.dart';

class RentalBillRepositoryImpl implements RentalBillRepository {
  final RentalBillApiService _apiService = sl<RentalBillApiService>();

  @override
  Future<Either<Failure, List<RentalBill>>> getMyBills({
    RentalBillStatus? status,
  }) async {
    return await _apiService.getMyBills(status: status);
  }

  @override
  Future<Either<Failure, RentalBill>> getBillDetail(int id) async {
    return await _apiService.getBillDetail(id);
  }

  @override
  Future<Either<Failure, RentalBill>> updateBill(
    UpdateRentalBillParams params,
  ) async {
    final request = UpdateRentalBillRequest(
      contactName: params.contactName,
      contactPhone: params.contactPhone,
      notes: params.notes,
      paymentMethod: params.paymentMethod,
      voucherCode: params.voucherCode,
      travelPointsUsed: params.travelPointsUsed,
    );
    return await _apiService.updateBill(params.id, request);
  }

  @override
  Future<Either<Failure, RentalBillPayResponse>> payBill(int id) async {
    return await _apiService.payBill(id);
  }

  @override
  Future<Either<Failure, SuccessResponse>> confirmQrPayment(
    ConfirmQrPaymentRequest params,
  ) async {
    return await _apiService.confirmQrPayment(params);
  }

  @override
  Future<Either<Failure, SuccessResponse>> userPickup(
    int id,
    File selfie,
  ) async {
    return await _apiService.userPickup(id, selfie);
  }

  @override
  Future<Either<Failure, SuccessResponse>> userReturnRequest(
    int id,
    List<File> photos,
    double latitude,
    double longitude,
  ) async {
    return await _apiService.userReturnRequest(id, photos, latitude, longitude);
  }

  @override
  Future<Either<Failure, SuccessResponse>> cancelBill(int id) async {
    return await _apiService.cancelBill(id);
  }
}
