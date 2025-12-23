import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/profile/data/models/user.dart';
import 'package:tour_guide_app/features/profile/data/models/update_initial_profile_model.dart';
import 'package:tour_guide_app/features/profile/data/models/update_verification_info_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> getMyProfile();
  Future<Either<Failure, User>> updateInitialProfile(
    UpdateInitialProfileModel body,
  );
  Future<Either<Failure, User>> updateVerificationInfo(
    UpdateVerificationInfoModel body,
  );
}
