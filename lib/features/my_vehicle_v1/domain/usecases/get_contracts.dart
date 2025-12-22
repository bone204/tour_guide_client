import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/my_vehicle_v1/data/models/contract_response.dart';
import 'package:tour_guide_app/features/my_vehicle_v1/data/models/contract.dart';
import 'package:tour_guide_app/features/my_vehicle_v1/domain/repository/my_vehicle_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetContractsUseCase {
  Future<Either<Failure, ContractResponse>> call({
    RentalContractStatus? status,
  }) async {
    return sl<MyVehicleRepository>().getContracts(status: status);
  }
}
