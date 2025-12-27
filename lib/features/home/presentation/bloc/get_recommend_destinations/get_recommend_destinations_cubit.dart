import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_response.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/get_recommend_destinations.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_recommend_destinations/get_recommend_destinations_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetRecommendDestinationsCubit
    extends Cubit<GetRecommendDestinationsState> {
  GetRecommendDestinationsCubit() : super(GetRecommendDestinationsInitial());

  Future<Either<Failure, DestinationResponse>> getRecommendDestinations({
    DestinationQuery? query,
  }) async {
    if (!isClosed) emit(GetRecommendDestinationsLoading());

    // Only offset, limit and province are used
    final params =
        query ??
        DestinationQuery(offset: 0, limit: 10, province: query?.province);

    final result = await sl<GetRecommendDestinationsUseCase>().call(params);

    result.fold(
      (failure) {
        if (!isClosed) emit(GetRecommendDestinationsError(failure.message));
      },
      (destinationResponse) {
        final hasReachedEnd = destinationResponse.items.length < params.limit;
        if (!isClosed) {
          emit(
            GetRecommendDestinationsLoaded(
              destinations: destinationResponse.items,
              params: params,
              hasReachedEnd: hasReachedEnd,
            ),
          );
        }
      },
    );

    return result;
  }

  Future<Either<Failure, DestinationResponse>>
  loadMoreRecommendDestinations() async {
    if (state is GetRecommendDestinationsLoaded) {
      final currentState = state as GetRecommendDestinationsLoaded;

      // Đã load hết data
      if (currentState.hasReachedEnd) {
        return Left(ServerFailure(message: 'Đã load hết dữ liệu'));
      }

      // Đang load more
      if (currentState.isLoadingMore) {
        return Left(ServerFailure(message: 'Đang load thêm dữ liệu'));
      }

      // Set loading more state
      if (!isClosed) emit(currentState.copyWith(isLoadingMore: true));

      final nextParams = DestinationQuery(
        offset: currentState.params.offset + currentState.params.limit,
        limit: currentState.params.limit,
        province: currentState.params.province,
      );

      final result = await sl<GetRecommendDestinationsUseCase>().call(
        nextParams,
      );

      result.fold(
        (failure) {
          // Trở về state cũ nhưng tắt loading
          if (!isClosed) emit(currentState.copyWith(isLoadingMore: false));
        },
        (destinationResponse) {
          final hasReachedEnd =
              destinationResponse.items.length < nextParams.limit;
          if (!isClosed) {
            emit(
              GetRecommendDestinationsLoaded(
                destinations: [
                  ...currentState.destinations,
                  ...destinationResponse.items,
                ],
                params: nextParams,
                hasReachedEnd: hasReachedEnd,
                isLoadingMore: false,
              ),
            );
          }
        },
      );

      return result;
    }

    return Left(ServerFailure(message: 'Invalid state'));
  }
}
