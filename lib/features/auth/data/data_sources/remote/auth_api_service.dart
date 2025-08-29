import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/features/auth/data/models/signin_params.dart';
import 'package:tour_guide_app/features/auth/data/models/signin_response.dart';
import 'package:tour_guide_app/features/auth/data/models/signup_params.dart';
import 'package:tour_guide_app/features/auth/data/models/signup_response.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class AuthApiService {
  Future<Either<Failure, SignUpResponse>> signUp(SignUpParams signupParams);
  Future<Either<Failure, SignInResponse>> signIn(SignInParams signinParams);
}

class AuthApiServiceImpl extends AuthApiService {

  @override
  Future<Either<Failure, SignUpResponse>> signUp(SignUpParams signupParams) async {
    try {
      final response = await sl<DioClient>().post(
        ApiUrls.register,
        data: signupParams.toMap(),
      );
      final signUpResponse = SignUpResponse.fromJson(response.data);
      return Right(signUpResponse);
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
  Future<Either<Failure, SignInResponse>> signIn(SignInParams signinParams) async {
    try {
      final response = await sl<DioClient>().post(
        ApiUrls.login,
        data: signinParams.toMap(),
      );

      final signInResponse = SignInResponse.fromJson(response.data);
      return Right(signInResponse);
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
