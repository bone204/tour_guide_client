import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract_params.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract_response.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle_rental_params.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle_response.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle.dart';

abstract class MyVehicleRepository {
  Future<Either<Failure, SuccessResponse>> registerRentalVehicle(
    ContractParams contractParams,
  );
  Future<Either<Failure, ContractResponse>> getContracts({
    RentalContractStatus? status,
  });
  Future<Either<Failure, SuccessResponse>> addVehicle(
    VehicleRentalParams vehicle,
  );
  Future<Either<Failure, VehicleResponse>> getVehicles({
    int? contractId,
    RentalVehicleApprovalStatus? status,
    RentalVehicleAvailabilityStatus? availability,
  });
}
