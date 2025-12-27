import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/motorbike_rental/data/models/motorbike_search_request.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';

abstract class MotorbikeRentalRepository {
  Future<Either<Failure, List<RentalVehicle>>> searchMotorbikes(
    MotorbikeSearchRequest request,
  );
}
