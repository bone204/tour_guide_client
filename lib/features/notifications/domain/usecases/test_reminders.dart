import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/notifications/domain/repository/notification_repository.dart';

class TestRemindersUseCase
    implements UseCase<Either<Failure, SuccessResponse>, NoParams> {
  final NotificationRepository repository;

  TestRemindersUseCase(this.repository);

  @override
  Future<Either<Failure, SuccessResponse>> call(NoParams params) async {
    return await repository.testReminders();
  }
}
