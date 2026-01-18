import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/bills/book_restaurant/data/models/restaurant_booking.dart';

abstract class BookRestaurantRepository {
  Future<Either<Failure, List<RestaurantBooking>>> getRestaurantBookings({
    String? status,
  });

  Future<Either<Failure, RestaurantBooking>> getRestaurantBookingDetail(int id);
}
