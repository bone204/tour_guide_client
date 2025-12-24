import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/auth/data/models/email_verification.dart';
import 'package:tour_guide_app/features/auth/data/models/email_verification_response.dart';
import 'package:tour_guide_app/features/auth/data/models/phone_verification.dart';
import 'package:tour_guide_app/features/auth/data/models/phone_verification_response.dart';
import 'package:tour_guide_app/features/auth/data/models/signin_params.dart';
import 'package:tour_guide_app/features/auth/data/models/signin_response.dart';
import 'package:tour_guide_app/features/auth/data/models/signup_params.dart';
import 'package:tour_guide_app/features/auth/data/models/signup_response.dart';

abstract class AuthRepository {
  Future<Either<Failure, SignUpResponse>> signUp(SignUpParams signupParams);
  Future<Either<Failure, SignInResponse>> signIn(SignInParams signinParams);
  Future<bool> isLoggedIn();

  Future<Either<Failure, EmailVerificationResponse>> emailStart();
  Future<Either<Failure, SuccessResponse>> emailVerify(EmailVerification emailVerification);

  Future<Either<Failure, PhoneVerificationResponse>> phoneStart(String recapchaToken);
  Future<Either<Failure, SuccessResponse>> phoneVerify(PhoneVerification phoneVerification);
}