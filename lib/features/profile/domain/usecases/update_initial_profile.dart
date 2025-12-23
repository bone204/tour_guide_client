import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/profile/data/models/user.dart';
import 'package:tour_guide_app/features/profile/domain/repository/profile_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

import 'package:tour_guide_app/features/profile/data/models/update_initial_profile_model.dart';

class UpdateInitialProfileUseCase
    implements UseCase<Either<Failure, User>, UpdateInitialProfileModel> {
  @override
  Future<Either<Failure, User>> call(UpdateInitialProfileModel params) async {
    return await sl<ProfileRepository>().updateInitialProfile(params);
  }
}
