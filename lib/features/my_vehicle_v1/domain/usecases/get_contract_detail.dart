import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/my_vehicle_v1/data/models/contract.dart';
import 'package:tour_guide_app/features/my_vehicle_v1/domain/repository/my_vehicle_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetContractDetailUseCase {
  final _repository = sl<MyVehicleRepository>();

  Future<Either<Failure, Contract>> call(int id) {
    return _repository.getContractById(id);
  }
}

