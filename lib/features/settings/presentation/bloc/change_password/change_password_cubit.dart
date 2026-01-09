import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/auth/data/models/change_password_model.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/change_password.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordCubit()
    : _changePasswordUseCase = sl<ChangePasswordUseCase>(),
      super(ChangePasswordInitial());

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (isClosed) return;

    emit(ChangePasswordLoading());

    final result = await _changePasswordUseCase.call(
      ChangePasswordModel(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(ChangePasswordFailure(failure.message));
        }
      },
      (success) {
        if (!isClosed) {
          emit(ChangePasswordSuccess(success.message));
        }
      },
    );
  }
}
