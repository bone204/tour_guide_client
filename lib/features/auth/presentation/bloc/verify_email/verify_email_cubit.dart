import 'package:bloc/bloc.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/features/auth/data/models/email_verification.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/email_start.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/verify_email.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/verify_email/verify_email_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  final EmailStartUseCase _emailStartUseCase;
  final VerifyEmailUseCase _verifyEmailUseCase;

  VerifyEmailCubit({
    EmailStartUseCase? emailStartUseCase,
    VerifyEmailUseCase? verifyEmailUseCase,
  }) : _emailStartUseCase = emailStartUseCase ?? sl<EmailStartUseCase>(),
       _verifyEmailUseCase = verifyEmailUseCase ?? sl<VerifyEmailUseCase>(),
       super(VerifyEmailInitial());

  Future<void> sendVerificationCode() async {
    emit(SendCodeLoading());
    final result = await _emailStartUseCase(NoParams());
    result.fold(
      (failure) => emit(VerifyEmailFailure(failure.message)),
      (response) => emit(
        SendCodeSuccess(
          token: response.token,
          message: 'Code sent successfully',
        ),
      ),
    );
  }

  Future<void> verifyEmail({
    required String email,
    required String code,
    required String token,
  }) async {
    emit(VerifyCodeLoading());
    final result = await _verifyEmailUseCase(
      EmailVerification(email: email, code: code, token: token),
    );
    result.fold(
      (failure) => emit(VerifyEmailFailure(failure.message)),
      (success) => emit(VerifyEmailSuccess(message: success.message)),
    );
  }
}
