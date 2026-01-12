import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/auth/data/models/phone_verification_response.dart';
import 'package:tour_guide_app/features/auth/domain/repository/auth_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

import 'package:tour_guide_app/core/usecases/no_params.dart';

class PhoneStartUseCase
    implements UseCase<Either<Failure, PhoneVerificationResponse>, NoParams> {
  @override
  Future<Either<Failure, PhoneVerificationResponse>> call(
    NoParams params,
  ) async {
    return await sl<AuthRepository>().phoneStart();
  }
}
