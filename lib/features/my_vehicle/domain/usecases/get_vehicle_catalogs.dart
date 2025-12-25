import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle_catalog.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/repository/my_vehicle_repository.dart';

class GetVehicleCatalogsUseCase {
  final MyVehicleRepository repository;

  GetVehicleCatalogsUseCase(this.repository);

  Future<Either<Failure, List<VehicleCatalog>>> call() async {
    return await repository.getVehicleCatalogs();
  }
}
