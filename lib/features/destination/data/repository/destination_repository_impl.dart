import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/destination/data/data_source/destination_api_service.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_response.dart';
import 'package:tour_guide_app/features/destination/data/models/feedback_request.dart';
import 'package:tour_guide_app/features/destination/domain/repository/destination_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class DestinationRepositoryImpl extends DestinationRepository {
  final _apiService = sl<DestinationApiService>();

  @override
  Future<Either<Failure, DestinationResponse>> getDestinations(
    DestinationQuery destinationQuery,
  ) async {
    return await _apiService.getDestinations(destinationQuery);
  }

  @override
  Future<Either<Failure, DestinationResponse>> getRecommendDestinations(
    DestinationQuery destinationQuery,
  ) async {
    return await _apiService.getRecommendDestinations(destinationQuery);
  }

  @override
  Future<Either<Failure, Destination>> getDestinationById(int id) async {
    return await _apiService.getDestinationById(id);
  }

  @override
  Future<Either<Failure, DestinationResponse>> getFavorites() async {
    return await _apiService.getFavorites();
  }

  @override
  Future<Either<Failure, Destination>> favoriteDestination(int id) async {
    return await _apiService.favoriteDestination(id);
  }

  @override
  Future<Either<Failure, SuccessResponse>> deleteFavoriteDestination(
    int id,
  ) async {
    return await _apiService.deleteFavoriteDestination(id);
  }

  @override
  Future<Either<Failure, SuccessResponse>> createFeedback(
    AddFeedbackRequest params,
  ) async {
    return await _apiService.createFeedback(params);
  }
}
