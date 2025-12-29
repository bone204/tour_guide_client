import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/add_vehicle_request.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract_params.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';

import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle_catalog.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';

abstract class MyVehicleRepository {
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
}
