import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_response.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/get_destinations.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_destinations/get_destination_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetDestinationCubit extends Cubit<GetDestinationState> {
  GetDestinationCubit() : super(GetDestinationInitial());

  Future<Either<Failure, DestinationResponse>> getDestinations({
    DestinationQuery? query,
  }) async {
    if (!isClosed) emit(GetDestinationLoading());

    final params = query ?? DestinationQuery(offset: 0, limit: 10);

    final result = await sl<GetDestinationUseCase>().call(params);

    result.fold(
      (failure) {
        if (!isClosed) emit(GetDestinationError(failure.message));
      },
      (destinationResponse) {
        final hasReachedEnd = destinationResponse.items.length < params.limit;
        if (!isClosed) {
          emit(
            GetDestinationLoaded(
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

  Future<Either<Failure, DestinationResponse>> loadMoreDestinations() async {
    if (state is GetDestinationLoaded) {
      final currentState = state as GetDestinationLoaded;

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
        q: currentState.params.q,
        available: currentState.params.available,
        province: currentState.params.province,
      );

      final result = await sl<GetDestinationUseCase>().call(nextParams);

      result.fold(
        (failure) {
          // Trở về state cũ nhưng tắt loading
          if (!isClosed) emit(currentState.copyWith(isLoadingMore: false));
          // Có thể show snackbar ở UI layer
        },
        (destinationResponse) {
          final hasReachedEnd =
              destinationResponse.items.length < nextParams.limit;
          if (!isClosed) {
            emit(
              GetDestinationLoaded(
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
