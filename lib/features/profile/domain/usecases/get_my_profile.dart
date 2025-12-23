import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/profile/data/models/user.dart';
import 'package:tour_guide_app/features/profile/domain/repository/profile_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetMyProfileUseCase implements UseCase<Either<Failure, User>, NoParams> {
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await sl<ProfileRepository>().getMyProfile();
  }
}
