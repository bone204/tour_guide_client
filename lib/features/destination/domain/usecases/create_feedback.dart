import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/destination/data/models/feedback_request.dart';
import 'package:tour_guide_app/features/destination/domain/repository/destination_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class CreateFeedbackUseCase implements UseCase<Either<Failure, SuccessResponse>, AddFeedbackRequest> {
  @override
  Future<Either<Failure, SuccessResponse>> call(AddFeedbackRequest params) async {
    return await sl<DestinationRepository>().createFeedback(params);
  }
}

