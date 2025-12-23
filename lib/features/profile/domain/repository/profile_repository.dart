import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/profile/data/models/user.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> getMyProfile();
}
