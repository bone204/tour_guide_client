import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/core/services/feedback/domain/repositories/feedback_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class CreateFeedbackReplyUseCase
    implements
        UseCase<Either<Failure, SuccessResponse>, CreateFeedbackReplyParams> {
  final FeedbackRepository _repository = sl<FeedbackRepository>();

  @override
  Future<Either<Failure, SuccessResponse>> call(
    CreateFeedbackReplyParams params,
  ) async {
    return await _repository.createReply(params.feedbackId, params.content);
  }
}

class CreateFeedbackReplyParams {
  final int feedbackId;
  final String content;

  CreateFeedbackReplyParams({required this.feedbackId, required this.content});
}
