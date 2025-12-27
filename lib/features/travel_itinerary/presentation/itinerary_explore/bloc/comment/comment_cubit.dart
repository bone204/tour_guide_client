import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/create_feedback_request.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback_query.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/create_feedback.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/get_feedback.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/comment/comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final GetFeedbackUseCase getFeedbackUseCase;
  final CreateFeedbackUseCase createFeedbackUseCase;
  static const int _limit = 10;

  CommentCubit({
    required this.getFeedbackUseCase,
    required this.createFeedbackUseCase,
  }) : super(CommentInitial());

  Future<void> loadComments(int itineraryId) async {
    if (isClosed) return;
    emit(CommentLoading());

    final query = FeedbackQuery(
      travelRouteId: itineraryId,
      offset: 0,
      limit: _limit,
    );

    final result = await getFeedbackUseCase(query);

    result.fold(
      (failure) {
        if (!isClosed) emit(CommentError(failure.message));
      },
      (response) {
        if (!isClosed) {
          emit(
            CommentLoaded(
              comments: response.items,
              params: query,
              hasReachedEnd: response.items.length < _limit,
            ),
          );
        }
      },
    );
  }

  Future<void> loadMoreComments() async {
    if (state is CommentLoaded) {
      final currentState = state as CommentLoaded;

      if (currentState.hasReachedEnd || currentState.isLoadingMore) return;

      if (!isClosed) emit(currentState.copyWith(isLoadingMore: true));

      final nextOffset = (currentState.params.offset ?? 0) + _limit;
      final nextParams = FeedbackQuery(
        travelRouteId: currentState.params.travelRouteId,
        offset: nextOffset,
        limit: _limit,
      );

      final result = await getFeedbackUseCase(nextParams);

      result.fold(
        (failure) {
          if (!isClosed) emit(currentState.copyWith(isLoadingMore: false));
          // Optionally emit an error state or show a snackbar via listener
        },
        (response) {
          if (!isClosed) {
            emit(
              currentState.copyWith(
                comments: [...currentState.comments, ...response.items],
                params: nextParams,
                hasReachedEnd: response.items.length < _limit,
                isLoadingMore: false,
              ),
            );
          }
        },
      );
    }
  }

  Future<void> addComment(int itineraryId, String content) async {
    // Optimistic update or refresh? Refresh is safer for now.
    // Or just append if successful.

    final request = CreateFeedbackRequest(
      star: 5,
      travelRouteId: itineraryId,
      comment: content,
    );

    final result = await createFeedbackUseCase(request);

    result.fold(
      (failure) {
        if (!isClosed) emit(CommentError(failure.message));
      },
      (success) {
        loadComments(itineraryId);
      },
    );
  }
}
