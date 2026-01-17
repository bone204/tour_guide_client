import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_search_response.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_table_search_request.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class RestaurantApiService {
  Future<Either<Failure, List<RestaurantSearchResponse>>>
  searchRestaurantTables(RestaurantTableSearchRequest request);
}

class RestaurantApiServiceImpl extends RestaurantApiService {
  @override
  Future<Either<Failure, List<RestaurantSearchResponse>>>
  searchRestaurantTables(RestaurantTableSearchRequest request) async {
    try {
      final response = await sl<DioClient>().get(
        "${ApiUrls.restaurantTables}/search",
        queryParameters: request.toJson(),
      );
      final List<dynamic> data = response.data;
      final restaurants =
          data.map((json) => RestaurantSearchResponse.fromJson(json)).toList();
      return Right(restaurants);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.response?.data['message'] ?? 'An error occurred during search',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
