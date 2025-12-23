import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/auth/data/data_sources/local/auth_local_service.dart';
import 'package:tour_guide_app/features/auth/data/data_sources/remote/auth_api_service.dart';
import 'package:tour_guide_app/features/auth/data/models/email_verification.dart';
import 'package:tour_guide_app/features/auth/data/models/email_verification_response.dart';
import 'package:tour_guide_app/features/auth/data/models/signin_params.dart';
import 'package:tour_guide_app/features/auth/data/models/signin_response.dart';
import 'package:tour_guide_app/features/auth/data/models/signup_params.dart';
import 'package:tour_guide_app/features/auth/data/models/signup_response.dart';
import 'package:tour_guide_app/features/auth/domain/repository/auth_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  final _localService = sl<AuthLocalService>();
  final _apiService = sl<AuthApiService>();

  @override
  Future<Either<Failure, SignUpResponse>> signUp(SignUpParams signupParams) async {
    return await _apiService.signUp(signupParams);
  }

  @override
  Future<Either<Failure, SignInResponse>> signIn(SignInParams signinParams) async {
    final result = await _apiService.signIn(signinParams);
    return await result.fold<Future<Either<Failure, SignInResponse>>>(
      (error) async => Left(error),
      (signInResponse) async {
        await _localService.saveTokens(signInResponse.accessToken, signInResponse.refreshToken);
        return Right(signInResponse);
      },
    );
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _localService.isLoggedIn();
  }

  @override
  Future<Either<Failure, EmailVerificationResponse>> emailStart() async {
    return await _apiService.emailStart();
  }

  @override
  Future<Either<Failure, SuccessResponse>> emailVerify(EmailVerification emailVerification) async {
    return await _apiService.emailVerify(emailVerification);
  }
}
