import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/update_contact_info/update_contact_info_state.dart';
import 'package:tour_guide_app/features/profile/data/models/update_initial_profile_model.dart';
import 'package:tour_guide_app/features/profile/domain/usecases/update_initial_profile.dart';

class UpdateContactInfoCubit extends Cubit<UpdateContactInfoState> {
  final UpdateInitialProfileUseCase updateInitialProfileUseCase;

  UpdateContactInfoCubit({required this.updateInitialProfileUseCase})
    : super(UpdateContactInfoInitial());

  Future<void> updateContactInfo({
    required String email,
    required String phone,
    String? nationality,
  }) async {
    if (isClosed) return;
    emit(UpdateContactInfoLoading());
    final result = await updateInitialProfileUseCase(
      UpdateInitialProfileModel(
        email: email,
        phone: phone,
        nationality: nationality,
      ),
    );

    if (isClosed) return;
    result.fold(
      (failure) => emit(UpdateContactInfoFailure(failure.message)),
      (_) => emit(UpdateContactInfoSuccess()),
    );
  }
}
