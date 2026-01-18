import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/bills/book_restaurant/data/models/restaurant_booking.dart';
import 'package:tour_guide_app/features/bills/book_restaurant/domain/repository/book_restaurant_repository.dart';

class GetRestaurantBookings
    implements UseCase<Either<Failure, List<RestaurantBooking>>, String?> {
  final BookRestaurantRepository repository;

  GetRestaurantBookings(this.repository);

  @override
  Future<Either<Failure, List<RestaurantBooking>>> call(String? status) {
    return repository.getRestaurantBookings(status: status);
  }
}
