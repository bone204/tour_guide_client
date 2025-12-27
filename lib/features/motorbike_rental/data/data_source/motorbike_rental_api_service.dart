import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/features/motorbike_rental/data/models/motorbike_search_request.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:dio/dio.dart';

abstract class MotorbikeRentalApiService {
  Future<Either<Failure, List<RentalVehicle>>> searchMotorbikes(
    MotorbikeSearchRequest request,
  );
}

class MotorbikeRentalApiServiceImpl extends MotorbikeRentalApiService {
  @override
  Future<Either<Failure, List<RentalVehicle>>> searchMotorbikes(
    MotorbikeSearchRequest request,
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
}
