import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/update_rental_bill_request.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill_pay_response.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/confirm_qr_payment_request.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class RentalBillApiService {
  Future<Either<Failure, List<RentalBill>>> getMyBills({
    RentalBillStatus? status,
  });
  Future<Either<Failure, RentalBill>> getBillDetail(int id);
  Future<Either<Failure, RentalBill>> updateBill(
    int id,
    UpdateRentalBillRequest body,
  );
  Future<Either<Failure, RentalBillPayResponse>> payBill(int id);
  Future<Either<Failure, SuccessResponse>> confirmQrPayment(
    ConfirmQrPaymentRequest body,
  );

  // Workflow
  Future<Either<Failure, SuccessResponse>> userPickup(int id, File selfie);
  Future<Either<Failure, SuccessResponse>> userReturnRequest(
    int id,
    List<File> photos,
    double latitude,
    double longitude,
  );
  Future<Either<Failure, SuccessResponse>> cancelBill(int id, String reason);
}

class RentalBillApiServiceImpl implements RentalBillApiService {
  @override
  Future<Either<Failure, List<RentalBill>>> getMyBills({
    RentalBillStatus? status,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (status != null) {
        // We need to pass the enum value string that matches backend expectation
        // Backend expects 'pending', 'confirmed', etc. which matches our JsonValue
        // However, standard toString() of enum might be 'RentalBillStatus.pending'.
        // We can use the logic that JSON serialization uses or just manual map if simple.
        // Or if we use enum_to_string or just .name (if names match).
        // The JsonValue annotation handles serialization, but for query params we usually do it manually
        // or rely on a helper. Here let's just use a simple regex or switch if name matches.
        // Actually, looking at the JsonValue, the values are lower_snake_case.

        // Let's create a helper or just use the name if it matches (it mostly does in camelCase vs snake_case).
        // 'paidPendingDelivery' -> 'paid_pending_delivery'.
        // Let's iterate values or better yet, since we have JsonValue, we could use that.
        // For now, let's manually map or assume specific string.
        // Actually, for query params, let's just pass the string if we can.
        // Let's check how other services handle enum search. `MotorbikeSearchRequest` had `toJson`.

        // I will trust the user to pass valid status or handle it.
        // But wait, the API expects string.
        // Let's look at `RentalBillStatus` in `rental_bill.dart`.
        // @JsonValue('paid_pending_delivery') paidPendingDelivery,

        // A quick way is to piggyback on json serialization logic or just switch.
        // Since there are few values, I'll just leave it dynamic or string for now?
        // No, strict typing is better.
        // Simpler: use the enum index or name? Backend uses string values.

        // I'll add a helper in the model file or just do a quick Map here.
        String? statusStr;
        switch (status) {
          case RentalBillStatus.pending:
            statusStr = 'pending';
            break;
          case RentalBillStatus.confirmed:
            statusStr = 'confirmed';
            break;
          case RentalBillStatus.paidPendingDelivery:
            statusStr = 'paid_pending_delivery';
            break;
          case RentalBillStatus.paid:
            statusStr = 'paid';
            break;
          case RentalBillStatus.cancelled:
            statusStr = 'cancelled';
            break;
          case RentalBillStatus.completed:
            statusStr = 'completed';
            break;
        }
        queryParameters['status'] = statusStr;
      }

      final response = await sl<DioClient>().get(
        "${ApiUrls.rentalBills}/me",
        queryParameters: queryParameters,
      );

      final List<dynamic> data = response.data;
      final bills = data.map((json) => RentalBill.fromJson(json)).toList();
      return Right(bills);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.response?.data['message'] ?? 'An error occurred fetching bills',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RentalBill>> getBillDetail(int id) async {
    try {
      final response = await sl<DioClient>().get("${ApiUrls.rentalBills}/$id");
      final bill = RentalBill.fromJson(response.data);
      return Right(bill);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.response?.data['message'] ??
              'An error occurred fetching bill detail',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RentalBill>> updateBill(
    int id,
    UpdateRentalBillRequest body,
  ) async {
    try {
      final response = await sl<DioClient>().patch(
        "${ApiUrls.rentalBills}/$id",
        data: body.toJson(),
      );
      final bill = RentalBill.fromJson(response.data);
      return Right(bill);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.response?.data['message'] ?? 'An error occurred updating bill',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RentalBillPayResponse>> payBill(int id) async {
    try {
      final response = await sl<DioClient>().patch(
        "${ApiUrls.rentalBills}/$id/pay",
      );
      final result = RentalBillPayResponse.fromJson(response.data);
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.response?.data['message'] ?? 'An error occurred paying bill',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SuccessResponse>> confirmQrPayment(
    ConfirmQrPaymentRequest body,
  ) async {
    try {
      final response = await sl<DioClient>().post(
        "${ApiUrls.payments}/qr/confirm",
        data: body.toJson(),
      );
      final result = SuccessResponse.fromJson(response.data);
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.response?.data['message'] ??
              'An error occurred confirming QR payment',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SuccessResponse>> userPickup(
    int id,
    File selfie,
  ) async {
    try {
      final formData = FormData();
      formData.files.add(
        MapEntry(
          'selfiePhoto',
          await MultipartFile.fromFile(
            selfie.path,
            filename: selfie.path.split('/').last,
          ),
        ),
      );

      final response = await sl<DioClient>().patch(
        '${ApiUrls.rentalBills}/$id/pickup',
        data: formData,
      );
      final successResponse = SuccessResponse.fromJson(response.data);
      return Right(successResponse);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.response?.data['message'] is List
                  ? (e.response?.data['message'] as List).join(', ')
                  : e.response?.data['message']?.toString() ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SuccessResponse>> userReturnRequest(
    int id,
    List<File> photos,
    double latitude,
    double longitude,
  ) async {
    try {
      final formData = FormData();
      formData.fields.add(MapEntry('latitude', latitude.toString()));
      formData.fields.add(MapEntry('longitude', longitude.toString()));
      for (var file in photos) {
        formData.files.add(
          MapEntry(
            'photos',
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
      }

      final response = await sl<DioClient>().patch(
        '${ApiUrls.rentalBills}/$id/return-request',
        data: formData,
      );
      final successResponse = SuccessResponse.fromJson(response.data);
      return Right(successResponse);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.response?.data['message'] is List
                  ? (e.response?.data['message'] as List).join(', ')
                  : e.response?.data['message']?.toString() ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SuccessResponse>> cancelBill(
    int id,
    String reason,
  ) async {
    try {
      final response = await sl<DioClient>().patch(
        '${ApiUrls.rentalBills}/$id/cancel',
        data: {'reason': reason},
      );
      final successResponse = SuccessResponse.fromJson(response.data);
      return Right(successResponse);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.response?.data['message'] is List
                  ? (e.response?.data['message'] as List).join(', ')
                  : e.response?.data['message']?.toString() ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
