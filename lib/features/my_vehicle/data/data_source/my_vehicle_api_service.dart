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
  Future<Either<Failure, SuccessResponse>> registerRentalVehicle(
    ContractParams contractParams,
  );
  Future<Either<Failure, ContractResponse>> getContracts({
    RentalContractStatus? status,
  });
  Future<Either<Failure, Contract>> getContractById(int id);
  Future<Either<Failure, SuccessResponse>> addVehicle(
    VehicleRentalParams vehicle,
  );
  Future<Either<Failure, VehicleResponse>> getVehicles({
    int? contractId,
    RentalVehicleApprovalStatus? status,
    RentalVehicleAvailabilityStatus? availability,
  });
  Future<Either<Failure, Vehicle>> getVehicleByLicensePlate(String licensePlate);
}

class MyVehicleApiServiceImpl extends MyVehicleApiService {
  @override
  Future<Either<Failure, SuccessResponse>> registerRentalVehicle(
    ContractParams contractParams,
  ) async {
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
  Future<Either<Failure, ContractResponse>> getContracts({
    RentalContractStatus? status,
  }) async {
    try {
      final response = await sl<DioClient>().get(
        ApiUrls.rentalContracts,
        queryParameters: {if (status != null) 'status': status.value},
      );

      final data = response.data;
      final List<dynamic> dataList =
          data is List
              ? data
              : (data['items'] as List<dynamic>? ??
                  data['data'] as List<dynamic>? ??
                  <dynamic>[]);

      final contracts =
          dataList
              .whereType<Map<String, dynamic>>()
              .map(Contract.fromJson)
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
      return Left(
        ServerFailure(message: 'Error parsing contracts: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Contract>> getContractById(int id) async {
    try {
      final response = await sl<DioClient>().get(
        '${ApiUrls.rentalContracts}/$id',
      );

      final data = response.data;
      Map<String, dynamic>? contractJson;

      if (data is Map<String, dynamic>) {
        if (data['data'] is Map<String, dynamic>) {
          contractJson = data['data'] as Map<String, dynamic>;
        } else {
          contractJson = data;
        }
      }

      if (contractJson == null) {
        return Left(
          ServerFailure(message: 'Contract data is not available'),
        );
      }

      return Right(Contract.fromJson(contractJson));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(message: 'Error parsing contract detail: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, SuccessResponse>> addVehicle(
    VehicleRentalParams vehicle,
  ) async {
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
  Future<Either<Failure, VehicleResponse>> getVehicles({
    int? contractId,
    RentalVehicleApprovalStatus? status,
    RentalVehicleAvailabilityStatus? availability,
  }) async {
    try {
      final response = await sl<DioClient>().get(
        ApiUrls.rentalVehicles,
        queryParameters: {
          if (contractId != null) 'contractId': contractId,
          if (status != null) 'status': status.value,
          if (availability != null) 'availability': availability.value,
        },
      );

      final data = response.data;
      final List<dynamic> dataList =
          data is List
              ? data
              : (data['items'] as List<dynamic>? ??
                  data['data'] as List<dynamic>? ??
                  <dynamic>[]);

      final vehicles =
          dataList
              .whereType<Map<String, dynamic>>()
              .map(Vehicle.fromJson)
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
      return Left(
        ServerFailure(message: 'Error parsing vehicles: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Vehicle>> getVehicleByLicensePlate(
    String licensePlate,
  ) async {
    try {
      final response = await sl<DioClient>().get(
        '${ApiUrls.rentalVehicles}/${Uri.encodeComponent(licensePlate)}',
      );

      final data = response.data;
      Map<String, dynamic>? vehicleJson;

      if (data is Map<String, dynamic>) {
        if (data['data'] is Map<String, dynamic>) {
          vehicleJson = data['data'] as Map<String, dynamic>;
        } else {
          vehicleJson = data;
        }
      }

      if (vehicleJson == null) {
        return Left(ServerFailure(message: 'Vehicle data is not available'));
      }

      return Right(Vehicle.fromJson(vehicleJson));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(message: 'Error parsing vehicle detail: ${e.toString()}'),
      );
    }
  }
}
