import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/bloc/button/button_state.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';

class ButtonStateCubit extends Cubit<ButtonState>{
  ButtonStateCubit() : super(ButtonInitialState());
  
  void execute({dynamic params, required UseCase usecase}) async {
    emit(ButtonLoadingState());
    await Future.delayed(const Duration(seconds: 2));
    try {
      Either result = await usecase.call(params);
      result.fold(
        (error) {
          emit(
            ButtonFailureState(errorMessage: error.message, statusCode: error.statusCode)
          );
        }, 
        (data) {
          emit(ButtonSuccessState());
        }
      );
    } catch (e) {
      emit(
        ButtonFailureState(errorMessage: e.toString(), statusCode: null)
      );
    }
  }
}
