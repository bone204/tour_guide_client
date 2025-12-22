import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/my_vehicle_v1/data/models/contract_params.dart';
import 'package:tour_guide_app/features/my_vehicle_v1/domain/repository/my_vehicle_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class RegisterRentalVehicleUseCase implements UseCase<Either<Failure, SuccessResponse>, ContractParams> {
  @override
  Future<Either<Failure, SuccessResponse>> call(ContractParams contractParams) async {
    return await sl<MyVehicleRepository>().registerRentalVehicle(contractParams);
  }
}

