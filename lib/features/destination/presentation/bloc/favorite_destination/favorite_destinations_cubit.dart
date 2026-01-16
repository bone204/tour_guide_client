import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_response.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/favorite_destination.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/get_favorites.dart';
import 'package:tour_guide_app/features/destination/presentation/bloc/favorite_destination/favorite_destinations_state.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/delete_favorite_destination.dart';
import 'package:tour_guide_app/service_locator.dart';

class FavoriteDestinationsCubit extends Cubit<FavoriteDestinationsState> {
  FavoriteDestinationsCubit() : super(FavoriteDestinationsState.initial());

  Future<void> loadFavorites() async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true, resetError: true));
    final result = await sl<GetFavoritesUseCase>().call(NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          hasLoaded: true,
          lastErrorMessage: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(
          favoriteIds: _mapResponseToIds(response),
          isLoading: false,
          hasLoaded: true,
          resetError: true,
        ),
      ),
    );
  }

  Future<bool> toggleFavorite(int destinationId) async {
    final previousIds = Set<int>.from(state.favoriteIds);
    final isCurrentlyFavorite = previousIds.contains(destinationId);
    final updatedIds = Set<int>.from(previousIds);

    if (isCurrentlyFavorite) {
      updatedIds.remove(destinationId);
    } else {
      updatedIds.add(destinationId);
    }

    emit(state.copyWith(favoriteIds: updatedIds, resetError: true));

    final Either<Failure, dynamic> result;
    if (isCurrentlyFavorite) {
      result = await sl<DeleteFavoriteDestinationUseCase>().call(destinationId);
    } else {
      result = await sl<FavoriteDestinationUseCase>().call(destinationId);
    }

    return result.fold((failure) {
      emit(
        state.copyWith(
          favoriteIds: previousIds,
          lastErrorMessage: failure.message,
        ),
      );
      return previousIds.contains(destinationId);
    }, (_) => updatedIds.contains(destinationId));
  }

  Set<int> _mapResponseToIds(DestinationResponse response) {
    return response.items.map((destination) => destination.id).toSet();
  }

  @override
  void emit(FavoriteDestinationsState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
