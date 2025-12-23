import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/features/profile/data/models/user.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class ProfileApiService {
  Future<Either<Failure, User>> getMyProfile();
}

class ProfileApiServiceImpl extends ProfileApiService {
  @override
  Future<Either<Failure, User>> getMyProfile() async {
    try {
      final response = await sl<DioClient>().get(
        "${ApiUrls.users}/profile/me",
      );
      final user = User.fromJson(response.data);
      return Right(user);
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
