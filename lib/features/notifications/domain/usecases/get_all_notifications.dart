import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/notifications/data/models/notification.dart';
import 'package:tour_guide_app/features/notifications/domain/repository/notification_repository.dart';

class GetAllNotificationsUseCase
    implements UseCase<Either<Failure, List<Notification>>, NoParams> {
  final NotificationRepository repository;

  GetAllNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Notification>>> call(NoParams params) async {
    return await repository.getAllNotifications();
  }
}
