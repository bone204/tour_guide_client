import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/auth/data/models/email_verification_response.dart';
import 'package:tour_guide_app/features/auth/domain/repository/auth_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class EmailStartUseCase implements UseCase<Either<Failure, EmailVerificationResponse>, NoParams> {
  @override
  Future<Either<Failure, EmailVerificationResponse>> call(NoParams params) async {
    return await sl<AuthRepository>().emailStart();
  }
}
