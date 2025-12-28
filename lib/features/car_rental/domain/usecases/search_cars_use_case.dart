import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/car_rental/data/models/car_search_request.dart';
import 'package:tour_guide_app/features/car_rental/domain/repository/car_rental_repository.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';
import 'package:tour_guide_app/service_locator.dart';

class SearchCarsUseCase
    implements UseCase<Either<Failure, List<RentalVehicle>>, CarSearchRequest> {
  @override
  Future<Either<Failure, List<RentalVehicle>>> call(
    CarSearchRequest params,
  ) async {
    return await sl<CarRentalRepository>().searchCars(params);
  }
}
