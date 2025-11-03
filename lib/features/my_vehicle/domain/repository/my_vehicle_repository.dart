import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract_params.dart';

abstract class MyVehicleRepository {
  Future<Either<Failure, SuccessResponse>> registerRentalVehicle(ContractParams contractParams);
  Future<Either<Failure, SuccessResponse>> getContracts(int userId);
}

