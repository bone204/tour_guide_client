import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_search_response.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_table_search_request.dart';
import 'package:tour_guide_app/features/restaurant/domain/repository/restaurant_repository.dart';

class SearchRestaurantTablesUseCase {
  final RestaurantRepository repository;

  SearchRestaurantTablesUseCase({required this.repository});

  Future<Either<Failure, List<RestaurantSearchResponse>>> call(
    RestaurantTableSearchRequest request,
  ) async {
    return await repository.searchRestaurantTables(request);
  }
}
