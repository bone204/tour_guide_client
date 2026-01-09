import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/profile/data/models/update_initial_profile_model.dart';
import 'package:tour_guide_app/features/profile/data/models/update_verification_info_model.dart';
import 'package:tour_guide_app/features/profile/domain/usecases/update_initial_profile.dart';

import 'package:tour_guide_app/features/profile/domain/usecases/update_avatar.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/edit_profile/edit_profile_state.dart';
import 'dart:io';

class EditProfileCubit extends Cubit<EditProfileState> {
  final UpdateInitialProfileUseCase updateInitialProfileUseCase;
  final UpdateAvatarUseCase updateAvatarUseCase;

  EditProfileCubit({
    required this.updateInitialProfileUseCase,
    required this.updateAvatarUseCase,
  }) : super(EditProfileInitial());

  Future<void> updateProfile({
    UpdateInitialProfileModel? initialProfile,
    UpdateVerificationInfoModel? verificationInfo,
    File? avatarFile,
  }) async {
    emit(EditProfileLoading());

    // Update Initial Profile
    if (initialProfile != null) {
      final result = await updateInitialProfileUseCase(initialProfile);
      if (isClosed) return;

      final isSuccess = result.fold((failure) {
        emit(EditProfileFailure(failure.message));
        return false;
      }, (_) => true);

      if (!isSuccess) return;
    }

    // Update Verification Info (merged into Initial Profile API)
    if (verificationInfo != null) {
      final mergedModel = UpdateInitialProfileModel(
        email: verificationInfo.email,
        phone: verificationInfo.phone,
        citizenId: verificationInfo.citizenId,
      );
      final result = await updateInitialProfileUseCase(mergedModel);
      if (isClosed) return;

      final isSuccess = result.fold((failure) {
        emit(EditProfileFailure(failure.message));
        return false;
      }, (_) => true);

      if (!isSuccess) return;
    }

    // Update Avatar
    if (avatarFile != null) {
      final result = await updateAvatarUseCase(avatarFile);
      if (isClosed) return;

      final isSuccess = result.fold((failure) {
        emit(EditProfileFailure(failure.message));
        return false;
      }, (_) => true);

      if (!isSuccess) return;
    }

    // If we haven't failed yet, emit success
    emit(EditProfileSuccess());
  }

  Future<void> updateAvatar(File avatar) async {
    emit(EditProfileLoading());
    final result = await updateAvatarUseCase(avatar);
    if (isClosed) return;
    result.fold(
      (failure) => emit(EditProfileFailure(failure.message)),
      (_) => emit(EditProfileSuccess()),
    );
  }
}
