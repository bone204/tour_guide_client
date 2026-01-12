import 'package:bloc/bloc.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/phone_start.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/verify_phone.dart';
import 'package:tour_guide_app/features/auth/data/models/phone_verification.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/verify_phone/verify_phone_state.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';

class VerifyPhoneCubit extends Cubit<VerifyPhoneState> {
  VerifyPhoneCubit() : super(VerifyPhoneInitial());

  Future<void> sendCode(String phone) async {
    emit(VerifyPhoneLoading());
    final result = await sl<PhoneStartUseCase>().call(NoParams());
    result.fold(
      (failure) => emit(VerifyPhoneFailure(failure.message)),
      (response) => emit(
        VerifyPhoneCodeSent(sessionInfo: response.sessionInfo, phone: phone),
      ),
    );
  }

  Future<void> verifyCode(String code, String phone, String sessionInfo) async {
    emit(VerifyPhoneVerifying());
    final verificationModel = PhoneVerification(
      phone: phone,
      code: code,
      sessionInfo: sessionInfo,
    );
    final result = await sl<VerifyPhoneUseCase>().call(verificationModel);
    result.fold(
      (failure) => emit(VerifyPhoneFailure(failure.message)),
      (success) => emit(VerifyPhoneSuccess()),
    );
  }

  void reset() {
    emit(VerifyPhoneInitial());
  }
}
