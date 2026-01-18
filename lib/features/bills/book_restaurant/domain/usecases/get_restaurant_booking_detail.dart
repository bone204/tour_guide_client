import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/bills/book_restaurant/data/models/restaurant_booking.dart';
import 'package:tour_guide_app/features/bills/book_restaurant/domain/repository/book_restaurant_repository.dart';

class GetRestaurantBookingDetail
    implements UseCase<Either<Failure, RestaurantBooking>, int> {
  final BookRestaurantRepository repository;

  GetRestaurantBookingDetail(this.repository);

  @override
  Future<Either<Failure, RestaurantBooking>> call(int id) {
    return repository.getRestaurantBookingDetail(id);
  }
}
