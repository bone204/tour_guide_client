import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/features/cooperations/data/models/cooperation_response.dart';
import 'package:tour_guide_app/features/cooperations/domain/usecases/get_favorite_cooperations.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_favorite_cooperations/get_favorite_cooperations_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetFavoriteCooperationsCubit extends Cubit<GetFavoriteCooperationsState> {
  GetFavoriteCooperationsCubit() : super(GetFavoriteCooperationsInitial());

  Future<Either<Failure, CooperationResponse>> getFavorites() async {
    emit(GetFavoriteCooperationsLoading());

    // Assuming you have GetFavoriteCooperationsUseCase.
    // If you used GetFavoritesUseCase in FavoriteCooperationsCubit, ensure it returns CooperationResponse.
    // Based on previous steps, GetFavoriteCooperationsUseCase exists.
    final result = await sl<GetFavoriteCooperationsUseCase>().call(NoParams());

    if (isClosed) return result;

    result.fold(
      (failure) => emit(GetFavoriteCooperationsError(failure.message)),
      (cooperationResponse) {
        emit(
          GetFavoriteCooperationsLoaded(
            cooperations: cooperationResponse.items,
          ),
        );
      },
    );

    return result;
  }
}
