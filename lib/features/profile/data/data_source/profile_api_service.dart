import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/features/profile/data/models/user.dart';
import 'package:tour_guide_app/features/profile/data/models/update_initial_profile_model.dart';
import 'package:tour_guide_app/features/profile/data/models/update_verification_info_model.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class ProfileApiService {
  Future<Either<Failure, User>> getMyProfile();
  Future<Either<Failure, User>> updateInitialProfile(
    UpdateInitialProfileModel body,
  );
  Future<Either<Failure, User>> updateVerificationInfo(
    UpdateVerificationInfoModel body,
  );
}

class ProfileApiServiceImpl extends ProfileApiService {
  @override
  Future<Either<Failure, User>> getMyProfile() async {
    try {
      final response = await sl<DioClient>().get("${ApiUrls.users}/profile/me");
      final user = User.fromJson(response.data);
      return Right(user);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: _parseErrorMessage(e.response?.data),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateInitialProfile(
    UpdateInitialProfileModel body,
  ) async {
    try {
      final response = await sl<DioClient>().patch(
        "${ApiUrls.users}/profile/initial",
        data: body.toJson(),
      );
      final user = User.fromJson(response.data);
      return Right(user);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: _parseErrorMessage(e.response?.data),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateVerificationInfo(
    UpdateVerificationInfoModel body,
  ) async {
    try {
      final response = await sl<DioClient>().patch(
        "${ApiUrls.users}/profile/verification-info",
        data: body.toJson(),
      );
      final user = User.fromJson(response.data);
      return Right(user);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: _parseErrorMessage(e.response?.data),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  String _parseErrorMessage(dynamic data) {
    try {
      if (data == null) return 'Unknown error';
      if (data is Map<String, dynamic> && data['message'] != null) {
        final message = data['message'];
        if (message is List) {
          return message.join('\n');
        }
        return message.toString();
      }
      return data.toString();
    } catch (_) {
      return 'Unknown error';
    }
  }
}
