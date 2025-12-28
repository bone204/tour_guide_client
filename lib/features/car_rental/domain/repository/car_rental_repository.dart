import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/car_rental/data/models/create_car_rental_bill_request.dart';
import 'package:tour_guide_app/features/car_rental/data/models/car_search_request.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';

abstract class CarRentalRepository {
  Future<Either<Failure, List<RentalVehicle>>> searchCars(
    CarSearchRequest request,
  );
  Future<Either<Failure, RentalVehicle>> getCarDetail(String licensePlate);
  Future<Either<Failure, RentalBill>> createRentalBill(
    CreateCarRentalBillRequest request,
  );
}
