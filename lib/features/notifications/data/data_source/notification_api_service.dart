import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/notifications/data/models/notification.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class NotificationApiService {
  Future<Either<Failure, List<Notification>>> getMyNotifications();
  Future<Either<Failure, List<Notification>>> getAllNotifications();
  Future<Either<Failure, SuccessResponse>> markAsRead(int id);
  Future<Either<Failure, SuccessResponse>> testReminders();
}

class NotificationApiServiceImpl implements NotificationApiService {
  @override
  Future<Either<Failure, List<Notification>>> getMyNotifications() async {
    try {
      final response = await sl<DioClient>().get(ApiUrls.notifications);
      final list =
          (response.data as List).map((e) => Notification.fromJson(e)).toList();
      return Right(list);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Notification>>> getAllNotifications() async {
    try {
      final response = await sl<DioClient>().get(
        '${ApiUrls.notifications}/all',
      );
      final list =
          (response.data as List).map((e) => Notification.fromJson(e)).toList();
      return Right(list);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SuccessResponse>> markAsRead(int id) async {
    try {
      final response = await sl<DioClient>().patch(
        '${ApiUrls.notifications}/$id/read',
      );
      return Right(SuccessResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SuccessResponse>> testReminders() async {
    try {
      final response = await sl<DioClient>().post(
        '${ApiUrls.notifications}/test/reminders',
      );
      return Right(SuccessResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
