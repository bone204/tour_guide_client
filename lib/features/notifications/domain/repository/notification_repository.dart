import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/notifications/data/models/notification.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<Notification>>> getMyNotifications();
  Future<Either<Failure, List<Notification>>> getAllNotifications();
  Future<Either<Failure, SuccessResponse>> markAsRead(int id);
  Future<Either<Failure, SuccessResponse>> testReminders();
}
