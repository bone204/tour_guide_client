import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_search_response.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_table_search_request.dart';
import 'package:tour_guide_app/features/restaurant/data/models/create_restaurant_booking_request.dart';

abstract class RestaurantRepository {
  Future<Either<Failure, List<RestaurantSearchResponse>>>
  searchRestaurantTables(RestaurantTableSearchRequest request);

  Future<Either<Failure, int>> createBooking(
    CreateRestaurantBookingRequest request,
  );
}
