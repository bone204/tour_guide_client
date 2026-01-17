import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/features/bills/book_hotel/data/models/hotel_bill.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class BookHotelApiService {
  Future<Either<Failure, List<HotelBill>>> getMyBills({
    HotelBillStatus? status,
  });
  Future<Either<Failure, HotelBill>> getBillDetail(int id);
  Future<Either<Failure, HotelBill>> updateBill(
    int id, {
    String? contactName,
    String? contactPhone,
    String? notes,
    String? voucherCode,
    double? travelPointsUsed,
  });
  Future<Either<Failure, HotelBill>> confirm(int id, String paymentMethod);
  Future<Either<Failure, HotelBill>> pay(int id);
  Future<Either<Failure, HotelBill>> cancel(int id, {String? reason});
  Future<Either<Failure, HotelBill>> checkIn(int id);
  Future<Either<Failure, HotelBill>> checkOut(int id);
}

class BookHotelApiServiceImpl implements BookHotelApiService {
  @override
  Future<Either<Failure, List<HotelBill>>> getMyBills({
    HotelBillStatus? status,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (status != null) {
        String? statusStr;
        switch (status) {
          case HotelBillStatus.pending:
            statusStr = 'pending';
            break;
          case HotelBillStatus.confirmed:
            statusStr = 'confirmed';
            break;
          case HotelBillStatus.paid:
            statusStr = 'paid';
            break;
          case HotelBillStatus.cancelled:
            statusStr = 'cancelled';
            break;
          case HotelBillStatus.completed:
            statusStr = 'completed';
            break;
        }
        queryParameters['status'] = statusStr;
      }

      final response = await sl<DioClient>().get(
        ApiUrls.hotelBills,
        queryParameters: queryParameters,
      );

      final List<dynamic> data = response.data;
      final bills = data.map((json) => HotelBill.fromJson(json)).toList();
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
  Future<Either<Failure, HotelBill>> getBillDetail(int id) async {
    try {
      final response = await sl<DioClient>().get("${ApiUrls.hotelBills}/$id");
      final bill = HotelBill.fromJson(response.data);
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
  Future<Either<Failure, HotelBill>> updateBill(
    int id, {
    String? contactName,
    String? contactPhone,
    String? notes,
    String? voucherCode,
    double? travelPointsUsed,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (contactName != null) data['contactName'] = contactName;
      if (contactPhone != null) data['contactPhone'] = contactPhone;
      if (notes != null) data['notes'] = notes;
      if (voucherCode != null) data['voucherCode'] = voucherCode;
      if (travelPointsUsed != null) data['travelPointsUsed'] = travelPointsUsed;

      final response = await sl<DioClient>().patch(
        '${ApiUrls.hotelBills}/$id',
        data: data,
      );
      final bill = HotelBill.fromJson(response.data);
      return Right(bill);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Update failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, HotelBill>> confirm(
    int id,
    String paymentMethod,
  ) async {
    try {
      final response = await sl<DioClient>().patch(
        '${ApiUrls.hotelBills}/$id/confirm',
        queryParameters: {'paymentMethod': paymentMethod},
      );
      final bill = HotelBill.fromJson(response.data);
      return Right(bill);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Confirm failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, HotelBill>> pay(int id) async {
    try {
      final response = await sl<DioClient>().patch(
        '${ApiUrls.hotelBills}/$id/pay',
      );
      final bill = HotelBill.fromJson(response.data);
      return Right(bill);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Payment failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, HotelBill>> cancel(int id, {String? reason}) async {
    try {
      final data = <String, dynamic>{};
      if (reason != null) {
        data['reason'] = reason;
      }
      final response = await sl<DioClient>().patch(
        '${ApiUrls.hotelBills}/$id/cancel',
        data: data,
      );
      final bill = HotelBill.fromJson(response.data);
      return Right(bill);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Cancellation failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, HotelBill>> checkIn(int id) async {
    try {
      final response = await sl<DioClient>().patch(
        '${ApiUrls.hotelBills}/$id/check-in',
      );
      final bill = HotelBill.fromJson(response.data);
      return Right(bill);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Check-in failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, HotelBill>> checkOut(int id) async {
    try {
      final response = await sl<DioClient>().patch(
        '${ApiUrls.hotelBills}/$id/check-out',
      );
      final bill = HotelBill.fromJson(response.data);
      return Right(bill);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Check-out failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
