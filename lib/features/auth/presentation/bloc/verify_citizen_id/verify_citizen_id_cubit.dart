import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/verify_citizen_id.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/verify_citizen_id/verify_citizen_id_state.dart';

class VerifyCitizenIdCubit extends Cubit<VerifyCitizenIdState> {
  final VerifyCitizenIdUseCase verifyCitizenIdUseCase;

  VerifyCitizenIdCubit({required this.verifyCitizenIdUseCase})
    : super(const VerifyCitizenIdState());

  void setCitizenFront(File image) {
    if (isClosed) return;
    emit(
      state.copyWith(
        citizenFront: image,
        status: VerifyCitizenIdStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void setSelfie(File image) {
    if (isClosed) return;
    emit(
      state.copyWith(
        selfie: image,
        status: VerifyCitizenIdStatus.initial,
        errorMessage: null,
      ),
    );
  }

  Future<void> submit() async {
    if (isClosed) return;
    if (state.citizenFront == null || state.selfie == null) return;

    emit(state.copyWith(status: VerifyCitizenIdStatus.loading));

    final result = await verifyCitizenIdUseCase(
      VerifyCitizenIdParams(
        citizenFrontPhoto: state.citizenFront!,
        selfiePhoto: state.selfie!,
      ),
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: VerifyCitizenIdStatus.failure,
              errorMessage: failure.message,
            ),
          );
        }
      },
      (success) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: VerifyCitizenIdStatus.success,
              successMessage: 'verify_success', // Localized key pending
            ),
          );
        }
      },
    );
  }
}
