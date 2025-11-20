import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/my_vehicle/data/data_source/my_vehicle_api_service.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract_params.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract_response.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle_rental_params.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle_response.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/repository/my_vehicle_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class MyVehicleRepositoryImpl extends MyVehicleRepository {
  final _apiService = sl<MyVehicleApiService>();

  @override
  Future<Either<Failure, SuccessResponse>> registerRentalVehicle(
    ContractParams contractParams,
  ) async {
    return _apiService.registerRentalVehicle(contractParams);
  }

  @override
  Future<Either<Failure, ContractResponse>> getContracts({
    RentalContractStatus? status,
  }) async {
    return _apiService.getContracts(status: status);
  }

  @override
  Future<Either<Failure, Contract>> getContractById(int id) {
    return _apiService.getContractById(id);
  }

  @override
  Future<Either<Failure, SuccessResponse>> addVehicle(
    VehicleRentalParams vehicle,
  ) async {
    return _apiService.addVehicle(vehicle);
  }

  @override
  Future<Either<Failure, VehicleResponse>> getVehicles({
    int? contractId,
    RentalVehicleApprovalStatus? status,
    RentalVehicleAvailabilityStatus? availability,
  }) async {
    return _apiService.getVehicles(
      contractId: contractId,
      status: status,
      availability: availability,
    );
  }

  @override
  Future<Either<Failure, Vehicle>> getVehicleByLicensePlate(String licensePlate) {
    return _apiService.getVehicleByLicensePlate(licensePlate);
  }
}
