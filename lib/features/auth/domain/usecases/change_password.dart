import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/auth/data/models/change_password_model.dart';
import 'package:tour_guide_app/features/auth/domain/repository/auth_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class ChangePasswordUseCase
    implements UseCase<Either<Failure, SuccessResponse>, ChangePasswordModel> {
  @override
  Future<Either<Failure, SuccessResponse>> call(
    ChangePasswordModel? param,
  ) async {
    if (param == null) {
      return Left(ServerFailure(message: "Change Password Params is null"));
    }
    return await sl<AuthRepository>().changePassword(param);
  }
}
