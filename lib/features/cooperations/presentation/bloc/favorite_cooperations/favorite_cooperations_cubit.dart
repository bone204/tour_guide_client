import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/features/cooperations/data/models/cooperation_response.dart';
import 'package:tour_guide_app/features/cooperations/domain/usecases/favorite_cooperation.dart';
import 'package:tour_guide_app/features/cooperations/domain/usecases/get_favorite_cooperations.dart';
import 'package:tour_guide_app/features/cooperations/domain/usecases/delete_favorite_cooperation.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/favorite_cooperations/favorite_cooperations_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class FavoriteCooperationsCubit extends Cubit<FavoriteCooperationsState> {
  FavoriteCooperationsCubit() : super(FavoriteCooperationsState.initial());

  Future<void> loadFavorites() async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true, resetError: true));
    final result = await sl<GetFavoriteCooperationsUseCase>().call(NoParams());
    result.fold(
      (failure) {
        print(
          "FavoriteCooperationsCubit: loadFavorites failed: ${failure.message}",
        );
        emit(
          state.copyWith(
            isLoading: false,
            hasLoaded: true,
            lastErrorMessage: failure.message,
          ),
        );
      },
      (response) {
        final ids = _mapResponseToIds(response);
        print("FavoriteCooperationsCubit: loadFavorites success. IDs: $ids");
        emit(
          state.copyWith(
            favoriteIds: ids,
            isLoading: false,
            hasLoaded: true,
            resetError: true,
          ),
        );
      },
    );
  }

  Future<bool> toggleFavorite(int cooperationId) async {
    final previousIds = Set<int>.from(state.favoriteIds);
    final isCurrentlyFavorite = previousIds.contains(cooperationId);
    final updatedIds = Set<int>.from(previousIds);

    if (isCurrentlyFavorite) {
      updatedIds.remove(cooperationId);
    } else {
      updatedIds.add(cooperationId);
    }

    emit(state.copyWith(favoriteIds: updatedIds, resetError: true));

    final Either<Failure, dynamic> result;
    if (isCurrentlyFavorite) {
      result = await sl<DeleteFavoriteCooperationUseCase>().call(cooperationId);
    } else {
      result = await sl<FavoriteCooperationUseCase>().call(
        FavoriteCooperationParams(id: cooperationId),
      );
    }

    return result.fold((failure) {
      emit(
        state.copyWith(
          favoriteIds: previousIds,
          lastErrorMessage: failure.message,
        ),
      );
      return isCurrentlyFavorite;
    }, (_) => updatedIds.contains(cooperationId));
  }

  Set<int> _mapResponseToIds(CooperationResponse response) {
    return response.items.map((cooperation) => cooperation.id).toSet();
  }

  @override
  void emit(FavoriteCooperationsState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
