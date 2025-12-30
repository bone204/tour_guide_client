import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/notifications/data/data_source/notification_api_service.dart';
import 'package:tour_guide_app/features/notifications/data/models/notification.dart';
import 'package:tour_guide_app/features/notifications/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationApiService apiService;

  NotificationRepositoryImpl({required this.apiService});

  @override
  Future<Either<Failure, List<Notification>>> getMyNotifications() async {
    return await apiService.getMyNotifications();
  }

  @override
  Future<Either<Failure, List<Notification>>> getAllNotifications() async {
    return await apiService.getAllNotifications();
  }

  @override
  Future<Either<Failure, SuccessResponse>> markAsRead(int id) async {
    return await apiService.markAsRead(id);
  }

  @override
  Future<Either<Failure, SuccessResponse>> testReminders() async {
    return await apiService.testReminders();
  }
}
