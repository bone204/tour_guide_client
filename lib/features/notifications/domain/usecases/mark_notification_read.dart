import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/notifications/domain/repository/notification_repository.dart';

class MarkNotificationReadUseCase
    implements
        UseCase<Either<Failure, SuccessResponse>, MarkNotificationReadParams> {
  final NotificationRepository repository;

  MarkNotificationReadUseCase(this.repository);

  @override
  Future<Either<Failure, SuccessResponse>> call(
    MarkNotificationReadParams params,
  ) async {
    return await repository.markAsRead(params.id);
  }
}

class MarkNotificationReadParams extends Equatable {
  final int id;

  const MarkNotificationReadParams({required this.id});

  @override
  List<Object?> get props => [id];
}
