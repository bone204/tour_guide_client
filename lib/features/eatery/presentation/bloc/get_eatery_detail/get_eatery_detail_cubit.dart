import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/eatery/data/models/eatery.dart';
import 'package:tour_guide_app/features/eatery/domain/usecases/get_eatery_detail_use_case.dart';

part 'get_eatery_detail_state.dart';

class GetEateryDetailCubit extends Cubit<GetEateryDetailState> {
  final GetEateryDetailUseCase _getEateryDetailUseCase;

  GetEateryDetailCubit(this._getEateryDetailUseCase)
    : super(GetEateryDetailInitial());

  Future<void> getEateryDetail(int id) async {
    emit(GetEateryDetailLoading());
    final result = await _getEateryDetailUseCase(id);
    result.fold(
      (failure) => emit(GetEateryDetailFailure(failure.message)),
      (eatery) => emit(GetEateryDetailSuccess(eatery)),
    );
  }
}
