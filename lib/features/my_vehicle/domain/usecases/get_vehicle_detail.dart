import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/repository/my_vehicle_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetVehicleDetailUseCase {
  final _repository = sl<MyVehicleRepository>();

  Future<Either<Failure, Vehicle>> call(String licensePlate) {
    return _repository.getVehicleByLicensePlate(licensePlate);
  }
}

