import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/motorbike_rental/data/models/motorbike_search_request.dart';
import 'package:tour_guide_app/features/motorbike_rental/domain/repository/motorbike_rental_repository.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';
import 'package:tour_guide_app/service_locator.dart';

class SearchMotorbikesUseCase
    implements
        UseCase<Either<Failure, List<RentalVehicle>>, MotorbikeSearchRequest> {
  @override
  Future<Either<Failure, List<RentalVehicle>>> call(
    MotorbikeSearchRequest params,
  ) async {
    return await sl<MotorbikeRentalRepository>().searchMotorbikes(params);
  }
}
