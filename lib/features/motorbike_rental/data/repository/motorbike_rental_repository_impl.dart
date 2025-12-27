import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/motorbike_rental/data/data_source/motorbike_rental_api_service.dart';
import 'package:tour_guide_app/features/motorbike_rental/data/models/create_rental_bill_request.dart';
import 'package:tour_guide_app/features/motorbike_rental/data/models/motorbike_search_request.dart';
import 'package:tour_guide_app/features/motorbike_rental/domain/repository/motorbike_rental_repository.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';
import 'package:tour_guide_app/service_locator.dart';

class MotorbikeRentalRepositoryImpl extends MotorbikeRentalRepository {
  final _apiService = sl<MotorbikeRentalApiService>();

  @override
  Future<Either<Failure, List<RentalVehicle>>> searchMotorbikes(
    MotorbikeSearchRequest request,
  ) {
    return _apiService.searchMotorbikes(request);
  }

  @override
  Future<Either<Failure, RentalVehicle>> getMotorbikeDetail(
    String licensePlate,
  ) {
    return _apiService.getMotorbikeDetail(licensePlate);
  }

  @override
  Future<Either<Failure, RentalBill>> createRentalBill(
    CreateRentalBillRequest request,
  ) {
    return _apiService.createRentalBill(request);
  }
}
