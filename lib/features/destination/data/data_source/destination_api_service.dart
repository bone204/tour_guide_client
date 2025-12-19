import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_response.dart';
import 'package:tour_guide_app/features/destination/data/models/feedback_request.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class DestinationApiService {
  Future<Either<Failure, DestinationResponse>> getDestinations(DestinationQuery destinationQuery);
  Future<Either<Failure, Destination>> getDestinationById(int id);
  Future<Either<Failure, DestinationResponse>> getFavorites();
  Future<Either<Failure, Destination>> favoriteDestination(int id);

  Future<Either<Failure, SuccessResponse>> createFeedback(AddFeedbackRequest addFeedbackRequest);
  
}

class DestinationApiServiceImpl extends DestinationApiService {

  @override
  Future<Either<Failure, DestinationResponse>> getDestinations(DestinationQuery destinationQuery) async {
    try {
      final response = await sl<DioClient>().get(
        ApiUrls.getDestinations,
        queryParameters: destinationQuery.toJson(),
      );
      final destinationResponse = DestinationResponse.fromJson(response.data);
      return Right(destinationResponse);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Destination>> getDestinationById(int id) async {
    try {
      final response = await sl<DioClient>().get(
        "${ApiUrls.getDestinations}/$id",
      );

      final destination = Destination.fromJson(response.data);
      return Right(destination);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DestinationResponse>> getFavorites() async {
    try {
      final response = await sl<DioClient>().get(
        ApiUrls.getFavoriteDestinations,
      );
      final destinationResponse = DestinationResponse.fromJson(response.data);
      return Right(destinationResponse);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Destination>> favoriteDestination(int id) async {
    try {
      final response = await sl<DioClient>().post(
        ApiUrls.favoriteDestination(id),
      );

      final destination = Destination.fromJson(response.data);
      return Right(destination);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SuccessResponse>> createFeedback(
    AddFeedbackRequest params,
  ) async {
    try {
      final response = await sl<DioClient>().post(
        ApiUrls.feedback,
        data: params.toJson(),
      );

      final successResponse = SuccessResponse.fromJson(response.data);
      return Right(successResponse);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
