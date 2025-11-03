import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract_params.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class MyVehicleApiService {
  Future<Either<Failure, SuccessResponse>> registerRentalVehicle(ContractParams contractParams);
  Future<Either<Failure, SuccessResponse>> getContracts(int userId);
}

class MyVehicleApiServiceImpl extends MyVehicleApiService {
  @override
  Future<Either<Failure, SuccessResponse>> registerRentalVehicle(ContractParams contractParams) async {
    try {
      final response = await sl<DioClient>().post(
        ApiUrls.rentalContract,
        data: contractParams.toJson(),
      );
      
      final successResponse = SuccessResponse.fromJson(response.data);
      return Right(successResponse);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SuccessResponse>> getContracts(int userId) async {
    try {
      final response = await sl<DioClient>().get(
        ApiUrls.rentalContract,
        queryParameters: {
          'userId': userId,
        },
      );

      final successResponse = SuccessResponse.fromJson(response.data);
      return Right(successResponse);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

