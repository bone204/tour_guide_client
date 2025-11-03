import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract_response.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/repository/my_vehicle_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetContractsUseCase {
  Future<Either<Failure, ContractResponse>> call(int id) async {
    return await sl<MyVehicleRepository>().getContracts(id);
  }
}

