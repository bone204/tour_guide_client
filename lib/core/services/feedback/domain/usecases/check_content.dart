import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/check_content_response.dart';
import 'package:tour_guide_app/core/services/feedback/domain/repositories/feedback_repository.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/service_locator.dart';

class CheckContentUseCase implements UseCase<Either<Failure, CheckContentResponse>, String> {
  @override
  Future<Either<Failure, CheckContentResponse>> call(String params) async {
    return await sl<FeedbackRepository>().checkContent(params);
  }
}
