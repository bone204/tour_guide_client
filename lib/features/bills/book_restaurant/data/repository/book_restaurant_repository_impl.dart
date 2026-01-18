import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/bills/book_restaurant/data/data_source/book_restaurant_api_service.dart';
import 'package:tour_guide_app/features/bills/book_restaurant/data/models/restaurant_booking.dart';
import 'package:tour_guide_app/features/bills/book_restaurant/domain/repository/book_restaurant_repository.dart';

class BookRestaurantRepositoryImpl implements BookRestaurantRepository {
  final BookRestaurantApiService apiService;

  BookRestaurantRepositoryImpl({required this.apiService});

  @override
  Future<Either<Failure, List<RestaurantBooking>>> getRestaurantBookings({
    String? status,
  }) {
    return apiService.getRestaurantBookings(status: status);
  }

  @override
  Future<Either<Failure, RestaurantBooking>> getRestaurantBookingDetail(
    int id,
  ) {
    return apiService.getRestaurantBookingDetail(id);
  }
}
