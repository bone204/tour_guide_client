import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract_params.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract_response.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle_rental_params.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle_response.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class MyVehicleApiService {
  Future<Either<Failure, SuccessResponse>> registerRentalVehicle(ContractParams contractParams);
  Future<Either<Failure, ContractResponse>> getContracts(int userId);
  Future<Either<Failure, SuccessResponse>> addVehicle(VehicleRentalParams vehicle);
  Future<Either<Failure, VehicleResponse>> getVehicles(int contractId);
}

class MyVehicleApiServiceImpl extends MyVehicleApiService {
  @override
  Future<Either<Failure, SuccessResponse>> registerRentalVehicle(ContractParams contractParams) async {
    try {
      await sl<DioClient>().post(
        ApiUrls.rentalContracts,
        data: contractParams.toJson(),
      );
      
      final successResponse = SuccessResponse(
        message: 'Contract registered successfully',
      );
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
  Future<Either<Failure, ContractResponse>> getContracts(int userId) async {
    try {
      final response = await sl<DioClient>().get(
        ApiUrls.rentalContracts,
        queryParameters: {
          'userId': userId,
        },
      );

      // API trả về array trực tiếp: [{...}, {...}]
      final List<dynamic> dataList = response.data as List<dynamic>;
      
      final contracts = dataList
          .map((item) {
            if (item is Map<String, dynamic>) {
              return Contract.fromJson(item);
            }
            return null;
          })
          .whereType<Contract>()
          .toList();
      
      return Right(ContractResponse(items: contracts));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Error parsing contracts: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, SuccessResponse>> addVehicle(VehicleRentalParams vehicle) async {
    try {
      await sl<DioClient>().post(
        ApiUrls.rentalVehicles,
        data: vehicle.toJson(),
      );
      
      final successResponse = SuccessResponse(
        message: 'Vehicle added successfully',
      );
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
  Future<Either<Failure, VehicleResponse>> getVehicles(int contractId) async {
    try {
      final response = await sl<DioClient>().get(
        ApiUrls.rentalVehicles,
        queryParameters: {
          'contractId': contractId,
        },
      );

      // API trả về array trực tiếp
      final List<dynamic> dataList = response.data as List<dynamic>;
      
      final vehicles = dataList
          .map((item) {
            if (item is Map<String, dynamic>) {
              return Vehicle.fromJson(item);
            }
            return null;
          })
          .whereType<Vehicle>()
          .toList();
      
      return Right(VehicleResponse(items: vehicles));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Error parsing vehicles: ${e.toString()}'));
    }
  }
}

