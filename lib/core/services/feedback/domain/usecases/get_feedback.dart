import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback_query.dart';
import 'package:tour_guide_app/core/services/feedback/domain/repositories/feedback_repository.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetFeedbackUseCase implements UseCase<Either<Failure, FeedbackResponse>, FeedbackQuery> {
  @override
  Future<Either<Failure, FeedbackResponse>> call(FeedbackQuery params) async {
    return await sl<FeedbackRepository>().getFeedback(params);
  }
}
