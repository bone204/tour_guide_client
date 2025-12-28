import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/car_rental/data/models/create_car_rental_bill_request.dart';
import 'package:tour_guide_app/features/car_rental/data/models/car_search_request.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class CarRentalApiService {
  Future<Either<Failure, List<RentalVehicle>>> searchCars(
    CarSearchRequest request,
  );
  Future<Either<Failure, RentalVehicle>> getCarDetail(
    String licensePlate,
  );
  Future<Either<Failure, RentalBill>> createRentalBill(
    CreateCarRentalBillRequest request,
  );
}

class CarRentalApiServiceImpl extends CarRentalApiService {
  @override
  Future<Either<Failure, List<RentalVehicle>>> searchCars(
    CarSearchRequest request,
  ) async {
    try {
      final response = await sl<DioClient>().get(
        "${ApiUrls.rentalVehicles}/search",
        queryParameters: request.toJson(),
      );
      final List<dynamic> data = response.data;
      final vehicles =
          data.map((json) => RentalVehicle.fromJson(json)).toList();
      return Right(vehicles);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.response?.data['message'] ?? 'An error occurred during search',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RentalVehicle>> getCarDetail(
    String licensePlate,
  ) async {
    try {
      final response = await sl<DioClient>().get(
        "${ApiUrls.rentalVehicles}/$licensePlate",
      );
      final vehicle = RentalVehicle.fromJson(response.data);
      return Right(vehicle);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.response?.data['message'] ??
              'An error occurred while fetching details',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RentalBill>> createRentalBill(
    CreateCarRentalBillRequest request,
  ) async {
    try {
      final response = await sl<DioClient>().post(
        // Use ApiUrls if available, otherwise fallback to literal string if it doesn't exist yet
        "/rental-bills",
        data: request.toJson(),
      );
      return Right(RentalBill.fromJson(response.data));
    } on DioException catch (e) {
      final message = e.response?.data['message'];
      return Left(
        ServerFailure(
          message:
              message is List
                  ? message.join(', ')
                  : message?.toString() ??
                      'An error occurred while creating rental bill',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
