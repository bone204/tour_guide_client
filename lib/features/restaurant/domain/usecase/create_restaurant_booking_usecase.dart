import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/restaurant/data/models/create_restaurant_booking_request.dart';
import 'package:tour_guide_app/features/restaurant/domain/repository/restaurant_repository.dart';

class CreateRestaurantBookingUseCase {
  final RestaurantRepository repository;

  CreateRestaurantBookingUseCase(this.repository);

  Future<Either<Failure, int>> call(
    CreateRestaurantBookingRequest request,
  ) async {
    return await repository.createBooking(request);
  }
}
