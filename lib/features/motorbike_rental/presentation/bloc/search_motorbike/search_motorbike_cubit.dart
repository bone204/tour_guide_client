import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/motorbike_rental/data/models/motorbike_search_request.dart';
import 'package:tour_guide_app/features/motorbike_rental/domain/usecases/search_motorbikes_use_case.dart';
import 'package:tour_guide_app/features/motorbike_rental/presentation/bloc/search_motorbike/search_motorbike_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class SearchMotorbikeCubit extends Cubit<SearchMotorbikeState> {
  SearchMotorbikeCubit() : super(const SearchMotorbikeState());

  Future<void> searchMotorbikes(MotorbikeSearchRequest request) async {
    emit(state.copyWith(status: SearchMotorbikeStatus.loading));

    final result = await sl<SearchMotorbikesUseCase>().call(request);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SearchMotorbikeStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (motorbikes) => emit(
        state.copyWith(
          status: SearchMotorbikeStatus.success,
          motorbikes: motorbikes,
        ),
      ),
    );
  }
}
