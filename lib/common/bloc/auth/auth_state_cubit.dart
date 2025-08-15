import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/bloc/auth/auth_state.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/is_logged_in.dart';
import 'package:tour_guide_app/service_locator.dart';

class AuthStateCubit extends Cubit<AuthState>{
  AuthStateCubit() : super(AppInitialState());

  void appStarted() async {
    try {
      var isLoggedIn = await sl<IsLoggedInUseCase>().call(NoParams());
      if (isLoggedIn) {
        await Future.delayed(const Duration(milliseconds: 100));
        emit(Authenticated());
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(UnAuthenticated());
    }
  }
}