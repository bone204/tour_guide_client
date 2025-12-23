import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/profile/data/models/update_initial_profile_model.dart';
import 'package:tour_guide_app/features/profile/data/models/update_verification_info_model.dart';
import 'package:tour_guide_app/features/profile/domain/usecases/update_initial_profile.dart';
import 'package:tour_guide_app/features/profile/domain/usecases/update_verification_info.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/edit_profile/edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final UpdateInitialProfileUseCase updateInitialProfileUseCase;
  final UpdateVerificationInfoUseCase updateVerificationInfoUseCase;

  EditProfileCubit({
    required this.updateInitialProfileUseCase,
    required this.updateVerificationInfoUseCase,
  }) : super(EditProfileInitial());

  Future<void> updateProfile({
    UpdateInitialProfileModel? initialProfile,
    UpdateVerificationInfoModel? verificationInfo,
  }) async {
    emit(EditProfileLoading());

    if (initialProfile != null) {
      final result = await updateInitialProfileUseCase(initialProfile);
      if (isClosed) return;
      result.fold(
        (failure) {
          emit(EditProfileFailure(failure.message));
          return;
        },
        (user) {
          // Success for initial profile, continue to verification info if needed
        },
      );
    }

    if (state is EditProfileFailure) return;

    if (verificationInfo != null) {
      final result = await updateVerificationInfoUseCase(verificationInfo);
      if (isClosed) return;
      result.fold(
        (failure) => emit(EditProfileFailure(failure.message)),
        (user) => emit(EditProfileSuccess()),
      );
    } else {
      // If only initial profile was updated and it was successful
      if (state is! EditProfileFailure) {
        emit(EditProfileSuccess());
      }
    }
  }
}
