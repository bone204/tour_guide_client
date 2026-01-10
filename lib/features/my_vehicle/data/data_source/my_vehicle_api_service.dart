import 'dart:io';
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
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle_catalog.dart';
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
  Future<Either<Failure, List<VehicleCatalog>>> getVehicleCatalogs();

  Future<Either<Failure, SuccessResponse>> enableVehicle(String licensePlate);
  Future<Either<Failure, SuccessResponse>> disableVehicle(String licensePlate);

  // Rental Bills
  Future<Either<Failure, List<RentalBill>>> getOwnerRentalBills(String? status);

  // Workflow
  Future<Either<Failure, SuccessResponse>> ownerDelivering(int id);
  Future<Either<Failure, SuccessResponse>> ownerDelivered(
    int id,
    List<File> photos,
    double latitude,
    double longitude,
  );
  Future<Either<Failure, SuccessResponse>> ownerConfirmReturn(
    int id,
    List<File> photos,
    double latitude,
    double longitude,
    bool? overtimeFeeAccepted,
  );
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
        data: await request.toFormData(),
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
  Future<Either<Failure, List<VehicleCatalog>>> getVehicleCatalogs() async {
    try {
      final response = await sl<DioClient>().get(ApiUrls.vehicleCatalogs);
      final List<dynamic> data = response.data;
      final catalogs =
          data.map((json) => VehicleCatalog.fromJson(json)).toList();
      return Right(catalogs);
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

  @override
  Future<Either<Failure, SuccessResponse>> enableVehicle(
    String licensePlate,
  ) async {
    try {
      final response = await sl<DioClient>().patch(
        '${ApiUrls.rentalVehicles}/$licensePlate/enable',
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
  Future<Either<Failure, SuccessResponse>> disableVehicle(
    String licensePlate,
  ) async {
    try {
      final response = await sl<DioClient>().patch(
        '${ApiUrls.rentalVehicles}/$licensePlate/disable',
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
  Future<Either<Failure, List<RentalBill>>> getOwnerRentalBills(
    String? status,
  ) async {
    try {
      final response = await sl<DioClient>().get(
        '${ApiUrls.rentalBills}/owner/me',
        queryParameters: {if (status != null) 'status': status},
      );
      final List<dynamic> data = response.data;
      final bills = data.map((json) => RentalBill.fromJson(json)).toList();
      return Right(bills);
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
  Future<Either<Failure, SuccessResponse>> ownerDelivering(int id) async {
    try {
      final response = await sl<DioClient>().patch(
        '${ApiUrls.rentalBills}/$id/delivering',
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
  Future<Either<Failure, SuccessResponse>> ownerDelivered(
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
        '${ApiUrls.rentalBills}/$id/delivered',
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
  Future<Either<Failure, SuccessResponse>> ownerConfirmReturn(
    int id,
    List<File> photos,
    double latitude,
    double longitude,
    bool? overtimeFeeAccepted,
  ) async {
    try {
      final formData = FormData();
      formData.fields.add(MapEntry('latitude', latitude.toString()));
      formData.fields.add(MapEntry('longitude', longitude.toString()));
      if (overtimeFeeAccepted != null) {
        formData.fields.add(
          MapEntry('overtimeFeeAccepted', overtimeFeeAccepted.toString()),
        );
      }

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
        '${ApiUrls.rentalBills}/$id/confirm-return',
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
}
