import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_response.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/get_favorites.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_favorites/get_favorites_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetFavoritesCubit extends Cubit<GetFavoritesState> {
  GetFavoritesCubit() : super(GetFavoritesInitial());

  Future<Either<Failure, DestinationResponse>> getFavorites() async {
    emit(GetFavoritesLoading());

    final result = await sl<GetFavoritesUseCase>().call(NoParams());

    if (isClosed) return result;

    result.fold((failure) => emit(GetFavoritesError(failure.message)), (
      destinationResponse,
    ) {
      emit(GetFavoritesLoaded(destinations: destinationResponse.items));
    });

    return result;
  }
}
