import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/cooperations/domain/usecases/get_cooperation_detail.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/cooperation_detail/cooperation_detail_state.dart';

class CooperationDetailCubit extends Cubit<CooperationDetailState> {
  final GetCooperationDetailUseCase getCooperationDetailUseCase;

  CooperationDetailCubit(this.getCooperationDetailUseCase)
    : super(CooperationDetailInitial());

  Future<void> getCooperationDetail(int id) async {
    if (isClosed) return;
    emit(CooperationDetailLoading());

    final result = await getCooperationDetailUseCase(
      GetCooperationDetailParams(id: id),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(CooperationDetailError(failure.message)),
      (cooperation) => emit(CooperationDetailLoaded(cooperation)),
    );
  }
}
