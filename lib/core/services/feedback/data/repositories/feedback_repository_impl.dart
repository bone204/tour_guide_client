import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/services/feedback/data/data_sources/feedback_api_service.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/create_feedback_request.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback_query.dart';
import 'package:tour_guide_app/core/services/feedback/domain/repositories/feedback_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class FeedbackRepositoryImpl extends FeedbackRepository {
  final _apiService = sl<FeedbackApiService>();

  @override
  Future<Either<Failure, FeedbackResponse>> getFeedback(
    FeedbackQuery query,
  ) {
    return _apiService.getFeedback(query);
  }

  @override
  Future<Either<Failure, SuccessResponse>> createFeedback(
    CreateFeedbackRequest request,
  ) {
    return _apiService.createFeedback(request);
  }
}


