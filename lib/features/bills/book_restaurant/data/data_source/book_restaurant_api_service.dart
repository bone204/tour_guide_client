import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/features/bills/book_restaurant/data/models/restaurant_booking.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class BookRestaurantApiService {
  Future<Either<Failure, List<RestaurantBooking>>> getRestaurantBookings({
    String? status,
  });

  Future<Either<Failure, RestaurantBooking>> getRestaurantBookingDetail(int id);
}

class BookRestaurantApiServiceImpl extends BookRestaurantApiService {
  @override
  Future<Either<Failure, List<RestaurantBooking>>> getRestaurantBookings({
    String? status,
  }) async {
    try {
      final response = await sl<DioClient>().get(
        ApiUrls.restaurantBookings,
        queryParameters: status != null ? {'status': status} : null,
      );
      final List<dynamic> data = response.data;
      final bookings =
          data.map((json) => RestaurantBooking.fromJson(json)).toList();
      return Right(bookings);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.response?.data['message'] ??
              'An error occurred while fetching bookings',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RestaurantBooking>> getRestaurantBookingDetail(
    int id,
  ) async {
    try {
      final response = await sl<DioClient>().get(
        "${ApiUrls.restaurantBookings}/$id",
      );
      return Right(RestaurantBooking.fromJson(response.data));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.response?.data['message'] ??
              'An error occurred while fetching booking detail',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
