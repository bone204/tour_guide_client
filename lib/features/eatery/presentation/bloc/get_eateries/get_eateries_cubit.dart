import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/eatery/data/models/eatery.dart';
import 'package:tour_guide_app/features/eatery/domain/usecases/get_eateries_use_case.dart';

part 'get_eateries_state.dart';

class GetEateriesCubit extends Cubit<GetEateriesState> {
  final GetEateriesUseCase _getEateriesUseCase;

  GetEateriesCubit(this._getEateriesUseCase) : super(GetEateriesInitial());

  Future<void> getEateries({String? province, String? keyword}) async {
    emit(GetEateriesLoading());
    final result = await _getEateriesUseCase(
      GetEateriesParams(province: province, keyword: keyword),
    );
    result.fold(
      (failure) => emit(GetEateriesFailure(failure.message)),
      (eateries) => emit(GetEateriesSuccess(eateries)),
    );
  }
}
