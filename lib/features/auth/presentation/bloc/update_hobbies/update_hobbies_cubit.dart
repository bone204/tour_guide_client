import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/update_hobbies.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/update_hobbies/update_hobbies_state.dart';

class UpdateHobbiesCubit extends Cubit<UpdateHobbiesState> {
  final UpdateHobbiesUseCase updateHobbiesUseCase;

  UpdateHobbiesCubit({required this.updateHobbiesUseCase})
    : super(UpdateHobbiesInitial());

  Future<void> updateHobbies(List<String> hobbies) async {
    emit(UpdateHobbiesLoading());
    final result = await updateHobbiesUseCase(hobbies);
    result.fold(
      (failure) => emit(UpdateHobbiesFailure(errorMessage: failure.message)),
      (success) => emit(UpdateHobbiesSuccess()),
    );
  }
}
