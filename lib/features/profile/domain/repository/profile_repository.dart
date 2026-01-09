import 'package:dartz/dartz.dart';
import 'dart:io';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/profile/data/models/user.dart';
import 'package:tour_guide_app/features/profile/data/models/update_initial_profile_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> getMyProfile();
  Future<Either<Failure, User>> updateInitialProfile(
    UpdateInitialProfileModel body,
  );

  Future<Either<Failure, String>> updateAvatar(File avatar);
}
