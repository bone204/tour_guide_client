import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/create_feedback_request.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback_query.dart';

abstract class FeedbackRepository {
  Future<Either<Failure, FeedbackResponse>> getFeedback(
    FeedbackQuery query,
  );
  Future<Either<Failure, SuccessResponse>> createFeedback(
    CreateFeedbackRequest request,
  );
}
