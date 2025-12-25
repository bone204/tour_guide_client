import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/my_vehicle/data/data_source/my_vehicle_api_service.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract_params.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/add_vehicle_request.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle_catalog.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/repository/my_vehicle_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class MyVehicleRepositoryImpl extends MyVehicleRepository {
  final _apiService = sl<MyVehicleApiService>();

  @override
  Future<Either<Failure, SuccessResponse>> addContract(
    ContractParams params,
  ) async {
    return _apiService.addContract(params);
  }

  @override
  Future<Either<Failure, ContractResponse>> getContracts(String? status) async {
    return _apiService.getContracts(status);
  }

  @override
  Future<Either<Failure, Contract>> getContractDetail(int id) async {
    return _apiService.getContractDetail(id);
  }

  @override
  Future<Either<Failure, SuccessResponse>> addVehicle(
    AddVehicleRequest request,
  ) async {
    return _apiService.addVehicle(request);
  }

  @override
  Future<Either<Failure, RentalVehicleResponse>> getMyVehicles(
    String? status,
  ) async {
    return _apiService.getMyVehicles(status);
  }

  @override
  Future<Either<Failure, RentalVehicle>> getVehicleDetail(
    String licensePlate,
  ) async {
    return _apiService.getVehicleDetail(licensePlate);
  }

  @override
  Future<Either<Failure, List<VehicleCatalog>>> getVehicleCatalogs() async {
    return _apiService.getVehicleCatalogs();
  }
}
