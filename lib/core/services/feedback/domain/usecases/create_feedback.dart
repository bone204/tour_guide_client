import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/create_feedback_request.dart';
import 'package:tour_guide_app/core/services/feedback/domain/repositories/feedback_repository.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/service_locator.dart';

class CreateFeedbackUseCase implements UseCase<Either<Failure, SuccessResponse>, CreateFeedbackRequest> {
  @override
  Future<Either<Failure, SuccessResponse>> call(CreateFeedbackRequest params) async {
    return await sl<FeedbackRepository>().createFeedback(params);
  }
}
