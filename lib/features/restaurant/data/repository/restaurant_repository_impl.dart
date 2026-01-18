import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/restaurant/data/data_source/restaurant_api_service.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_search_response.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_table_search_request.dart';
import 'package:tour_guide_app/features/restaurant/data/models/create_restaurant_booking_request.dart';
import 'package:tour_guide_app/features/restaurant/domain/repository/restaurant_repository.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantApiService apiService;

  RestaurantRepositoryImpl({required this.apiService});

  @override
  Future<Either<Failure, List<RestaurantSearchResponse>>>
  searchRestaurantTables(RestaurantTableSearchRequest request) async {
    return await apiService.searchRestaurantTables(request);
  }

  @override
  Future<Either<Failure, int>> createBooking(
    CreateRestaurantBookingRequest request,
  ) async {
    return await apiService.createBooking(request);
  }
}
