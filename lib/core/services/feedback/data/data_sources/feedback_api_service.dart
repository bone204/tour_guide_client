import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/create_feedback_request.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback_query.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class FeedbackApiService {
  Future<Either<Failure, SuccessResponse>> createFeedback(
    CreateFeedbackRequest request,
  );

  Future<Either<Failure, FeedbackResponse>> getFeedback(
    FeedbackQuery query,
  );
}

class FeedbackApiServiceImpl extends FeedbackApiService {
  @override
  Future<Either<Failure, SuccessResponse>> createFeedback(
    CreateFeedbackRequest request,
  ) async {
    try {
      final response = await sl<DioClient>().post(ApiUrls.feedback, data: request.toJson());
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

  @override
  Future<Either<Failure, FeedbackResponse>> getFeedback(
    FeedbackQuery query,
  ) async {
    try {
      final response = await sl<DioClient>().post(ApiUrls.feedback, data: query.toQuery());
      final feedbackResponse = FeedbackResponse.fromJson(response.data);
      return Right(feedbackResponse);
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
