import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/car_rental/data/data_source/car_rental_api_service.dart';
import 'package:tour_guide_app/features/car_rental/data/models/create_car_rental_bill_request.dart';
import 'package:tour_guide_app/features/car_rental/data/models/car_search_request.dart';
import 'package:tour_guide_app/features/car_rental/domain/repository/car_rental_repository.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';
import 'package:tour_guide_app/service_locator.dart';

class CarRentalRepositoryImpl extends CarRentalRepository {
  final _apiService = sl<CarRentalApiService>();

  @override
  Future<Either<Failure, List<RentalVehicle>>> searchCars(
    CarSearchRequest request,
  ) {
    return _apiService.searchCars(request);
  }

  @override
  Future<Either<Failure, RentalVehicle>> getCarDetail(String licensePlate) {
    return _apiService.getCarDetail(licensePlate);
  }

  @override
  Future<Either<Failure, RentalBill>> createRentalBill(
    CreateCarRentalBillRequest request,
  ) {
    return _apiService.createRentalBill(request);
  }
}
