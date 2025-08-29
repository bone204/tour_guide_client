import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/auth/data/models/signup_params.dart';
import 'package:tour_guide_app/features/auth/data/models/signup_response.dart';
import 'package:tour_guide_app/features/auth/domain/repository/auth_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class SignUpUseCase implements UseCase<Either, SignUpParams> {
  @override
  Future<Either<Failure, SignUpResponse>> call(SignUpParams ? param) async{
    if (param == null) {
      return Left(ServerFailure(message: "Sign Up Params is null"));
    }
    return await sl<AuthRepository>().signUp(param);
  }

}