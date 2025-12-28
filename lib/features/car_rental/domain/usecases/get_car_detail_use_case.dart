import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/car_rental/domain/repository/car_rental_repository.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetCarDetailUseCase
    implements UseCase<Either<Failure, RentalVehicle>, String> {
  @override
  Future<Either<Failure, RentalVehicle>> call(String params) {
    return sl<CarRentalRepository>().getCarDetail(params);
  }
}
