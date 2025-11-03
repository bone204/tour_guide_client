import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/my_vehicle/data/data_source/my_vehicle_api_service.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract_params.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/repository/my_vehicle_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class MyVehicleRepositoryImpl extends MyVehicleRepository {
  final _apiService = sl<MyVehicleApiService>();

  @override
  Future<Either<Failure, SuccessResponse>> registerRentalVehicle(ContractParams contractParams) async {
    return await _apiService.registerRentalVehicle(contractParams);
  }

  @override
  Future<Either<Failure, SuccessResponse>> getContracts(int userId) async {
    return await _apiService.getContracts(userId);
  }
}

