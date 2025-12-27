import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback.dart';
import 'package:tour_guide_app/core/services/feedback/domain/repositories/feedback_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetFeedbackRepliesUseCase
    implements UseCase<Either<Failure, FeedbackReplyResponse>, int> {
  final FeedbackRepository _repository = sl<FeedbackRepository>();

  @override
  Future<Either<Failure, FeedbackReplyResponse>> call(int feedbackId) async {
    return await _repository.getReplies(feedbackId);
  }
}
