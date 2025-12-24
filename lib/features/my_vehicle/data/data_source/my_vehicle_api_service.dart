import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/add_vehicle_request.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract_params.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class MyVehicleApiService {
  Future<Either<Failure, SuccessResponse>> addContract(ContractParams params);
  Future<Either<Failure, ContractResponse>> getContracts(String? status);
  Future<Either<Failure, Contract>> getContractDetail(int id);

  // Rental Vehicles
  Future<Either<Failure, SuccessResponse>> addVehicle(
    AddVehicleRequest request,
  );
  Future<Either<Failure, RentalVehicleResponse>> getMyVehicles(String? status);
  Future<Either<Failure, RentalVehicle>> getVehicleDetail(String licensePlate);
}

class MyVehicleApiServiceImpl extends MyVehicleApiService {
  @override
  Future<Either<Failure, SuccessResponse>> addContract(
    ContractParams params,
  ) async {
    try {
      final response = await sl<DioClient>().post(
        ApiUrls.rentalContracts,
        data: await params.toFormData(),
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
  Future<Either<Failure, ContractResponse>> getContracts(String? status) async {
    try {
      final response = await sl<DioClient>().get(
        "${ApiUrls.rentalContracts}/me",
        queryParameters: {if (status != null) 'status': status},
      );
      final contractResponse = ContractResponse.fromJson(response.data);
      return Right(contractResponse);
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
  Future<Either<Failure, Contract>> getContractDetail(int id) async {
    try {
      final response = await sl<DioClient>().get(
        '${ApiUrls.rentalContracts}/$id',
      );
      final contract = Contract.fromJson(response.data);
      return Right(contract);
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
  Future<Either<Failure, SuccessResponse>> addVehicle(
    AddVehicleRequest request,
  ) async {
    try {
      final response = await sl<DioClient>().post(
        ApiUrls.rentalVehicles,
        data: request.toJson(),
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
  Future<Either<Failure, RentalVehicleResponse>> getMyVehicles(
    String? status,
  ) async {
    try {
      final response = await sl<DioClient>().get(
        "${ApiUrls.rentalVehicles}/me",
        queryParameters: {if (status != null) 'status': status},
      );
      final vehicleResponse = RentalVehicleResponse.fromJson(response.data);
      return Right(vehicleResponse);
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
  Future<Either<Failure, RentalVehicle>> getVehicleDetail(
    String licensePlate,
  ) async {
    try {
      final response = await sl<DioClient>().get(
        '${ApiUrls.rentalVehicles}/$licensePlate',
      );
      final vehicle = RentalVehicle.fromJson(response.data);
      return Right(vehicle);
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
