import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/auth/data/models/email_verification.dart';
import 'package:tour_guide_app/features/auth/domain/repository/auth_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class VerifyEmailUseCase implements UseCase<Either<Failure, SuccessResponse>, EmailVerification> {
  @override
  Future<Either<Failure, SuccessResponse>> call(EmailVerification params) async {
    return await sl<AuthRepository>().emailVerify(params);
  }
}
