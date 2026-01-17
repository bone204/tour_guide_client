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
  Future<Either<Failure, HotelBill>> cancel(int id);
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

      // GET /hotel-bills
      final response = await sl<DioClient>().get(
        "hotel-bills",
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
      // GET /hotel-bills/:id
      final response = await sl<DioClient>().get("hotel-bills/$id");
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

      // PATCH /hotel-bills/:id
      final response = await sl<DioClient>().patch(
        'hotel-bills/$id',
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
      // PATCH /hotel-bills/:id/confirm?paymentMethod=...
      final response = await sl<DioClient>().patch(
        'hotel-bills/$id/confirm',
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
      // PATCH /hotel-bills/:id/pay
      final response = await sl<DioClient>().patch('hotel-bills/$id/pay');
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
  Future<Either<Failure, HotelBill>> cancel(int id) async {
    try {
      // PATCH /hotel-bills/:id/cancel
      final response = await sl<DioClient>().patch('hotel-bills/$id/cancel');
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
}
