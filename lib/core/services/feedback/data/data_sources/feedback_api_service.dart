import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/check_content_response.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/create_feedback_request.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback_query.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class FeedbackApiService {
  Future<Either<Failure, SuccessResponse>> createFeedback(
    CreateFeedbackRequest request,
  );

  Future<Either<Failure, FeedbackResponse>> getFeedback(FeedbackQuery query);

  Future<Either<Failure, CheckContentResponse>> checkContent(String content);

  Future<Either<Failure, SuccessResponse>> createReply(
    int feedbackId,
    String content,
  );

  Future<Either<Failure, FeedbackReplyResponse>> getReplies(int feedbackId);
}

class FeedbackApiServiceImpl extends FeedbackApiService {
  @override
  Future<Either<Failure, SuccessResponse>> createFeedback(
    CreateFeedbackRequest request,
  ) async {
    try {
      final response = await sl<DioClient>().post(
        ApiUrls.feedback,
        data: request.toJson(),
      );
      final successResponse = SuccessResponse.fromJson(response.data);
      return Right(successResponse);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message']?.toString() ?? 'Unknown error',
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
      final response = await sl<DioClient>().get(
        ApiUrls.feedback,
        queryParameters: query.toQuery(),
      );
      final feedbackResponse = FeedbackResponse.fromJson(response.data);
      return Right(feedbackResponse);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message']?.toString() ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CheckContentResponse>> checkContent(
    String content,
  ) async {
    try {
      final response = await sl<DioClient>().post(
        '${ApiUrls.feedback}/check-content',
        data: {'content': content},
      );
      final checkResponse = CheckContentResponse.fromJson(response.data);
      return Right(checkResponse);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message']?.toString() ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SuccessResponse>> createReply(
    int feedbackId,
    String content,
  ) async {
    try {
      final response = await sl<DioClient>().post(
        '${ApiUrls.feedback}/$feedbackId/replies',
        data: {'content': content},
      );
      final successResponse = SuccessResponse.fromJson(response.data);
      return Right(successResponse);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message']?.toString() ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FeedbackReplyResponse>> getReplies(
    int feedbackId,
  ) async {
    try {
      final response = await sl<DioClient>().get(
        '${ApiUrls.feedback}/$feedbackId/replies',
      );
      // Backend returns list of replies directly?
      // Checking feedback.controller.ts: return this.feedbackService.listReplies(feedbackId);
      // Service returns FeedbackReply[].
      // FeedbackReplyResponse expects { items: [] } or List.
      // FeedbackReplyResponse.fromJson handles List input.
      final replyResponse = FeedbackReplyResponse.fromJson(response.data);
      return Right(replyResponse);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message']?.toString() ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
