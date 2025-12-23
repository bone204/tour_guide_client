import 'package:dartz/dartz.dart';
import 'dart:io';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/profile/domain/repository/profile_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class UpdateAvatarUseCase implements UseCase<Either<Failure, String>, File> {
  @override
  Future<Either<Failure, String>> call(File params) async {
    return await sl<ProfileRepository>().updateAvatar(params);
  }
}
