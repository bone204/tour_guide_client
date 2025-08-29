import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/auth/data/models/signin_params.dart';
import 'package:tour_guide_app/features/auth/data/models/signin_response.dart';
import 'package:tour_guide_app/features/auth/domain/repository/auth_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class SignInUseCase implements UseCase<Either<Failure, SignInResponse>, SignInParams> {
  @override
  Future<Either<Failure, SignInResponse>> call(SignInParams? param) async {
    if (param == null) {
      return Left(ServerFailure(message: "Sign In Params is null"));
    }
    return await sl<AuthRepository>().signIn(param);
  }
}
