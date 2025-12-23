import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/features/profile/domain/usecases/get_my_profile.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_state.dart';

class GetMyProfileCubit extends Cubit<GetMyProfileState> {
  final GetMyProfileUseCase _getMyProfileUseCase;

  GetMyProfileCubit(this._getMyProfileUseCase) : super(GetMyProfileInitial());

  Future<void> getMyProfile() async {
    emit(GetMyProfileLoading());
    final result = await _getMyProfileUseCase(NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(GetMyProfileFailure(failure.message)),
      (user) => emit(GetMyProfileSuccess(user)),
    );
  }
}
