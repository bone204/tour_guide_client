import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/repository/my_vehicle_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetMyContractsUseCase implements UseCase<Either<Failure, ContractResponse>, String> {
  @override
  Future<Either<Failure, ContractResponse>> call(String? status) async {
    return await sl<MyVehicleRepository>().getContracts(status);
  }
}
