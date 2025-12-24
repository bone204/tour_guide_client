import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/auth/data/models/phone_verification.dart';
import 'package:tour_guide_app/features/auth/domain/repository/auth_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class VerifyPhoneUseCase implements UseCase<Either<Failure, SuccessResponse>, PhoneVerification> {
  @override
  Future<Either<Failure, SuccessResponse>> call(PhoneVerification params) async {
    return await sl<AuthRepository>().phoneVerify(params);
  }
}
