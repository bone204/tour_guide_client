import 'package:dartz/dartz.dart';
import 'dart:io';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/profile/data/data_source/profile_api_service.dart';
import 'package:tour_guide_app/features/profile/data/models/update_initial_profile_model.dart';
import 'package:tour_guide_app/features/profile/data/models/update_verification_info_model.dart';
import 'package:tour_guide_app/features/profile/data/models/user.dart';
import 'package:tour_guide_app/features/profile/domain/repository/profile_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final _apiService = sl<ProfileApiService>();

  @override
  Future<Either<Failure, User>> getMyProfile() async {
    return _apiService.getMyProfile();
  }

  @override
  Future<Either<Failure, User>> updateInitialProfile(
    UpdateInitialProfileModel body,
  ) async {
    return _apiService.updateInitialProfile(body);
  }

  @override
  Future<Either<Failure, User>> updateVerificationInfo(
    UpdateVerificationInfoModel body,
  ) async {
    return _apiService.updateVerificationInfo(body);
  }

  @override
  Future<Either<Failure, String>> updateAvatar(File avatar) async {
    return _apiService.updateAvatar(avatar);
  }
}
