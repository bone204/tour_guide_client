import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/create_feedback_request.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback_query.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/create_feedback.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/get_feedback.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/check_content.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/comment/comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final GetFeedbackUseCase getFeedbackUseCase;
  final CreateFeedbackUseCase createFeedbackUseCase;
  final CheckContentUseCase checkContentUseCase;
  static const int _limit = 10;

  CommentCubit({
    required this.getFeedbackUseCase,
    required this.createFeedbackUseCase,
    required this.checkContentUseCase,
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
    if (content.trim().length < 5) {
      _emitError('too_short');
      return;
    }
    // 1. Check content first
    final checkResult = await checkContentUseCase(content);

    await checkResult.fold(
      (failure) async {
        _emitError(failure.message);
      },
      (checkResponse) async {
        // 2. Decide based on checkResponse
        if (checkResponse.decision == 'reject') {
          if (!isClosed) {
            // Map reasons to localization keys
            final reasons = checkResponse.reasons ?? [];
            final localizedReasons =
                reasons.isNotEmpty ? reasons.join(',') : 'rule_reject';
            _emitError('feedbackContentRejected:$localizedReasons');
          }
          return;
        }

        String? warningMsg;
        if (checkResponse.decision == 'manual_review') {
          warningMsg = 'feedbackContentUnderReview';
        }

        // 3. If approved or manual_review, proceed to create
        final request = CreateFeedbackRequest(
          star: 5,
          travelRouteId: itineraryId,
          comment: content,
        );

        final createResult = await createFeedbackUseCase(request);

        createResult.fold(
          (failure) {
            _emitError(failure.message);
          },
          (success) {
            _reloadAndShowWarning(itineraryId, warningMsg);
          },
        );
      },
    );
  }

  void _emitError(String message) {
    if (isClosed) return;
    if (state is CommentLoaded) {
      final currentState = state as CommentLoaded;
      emit(currentState.copyWith(errorMessage: message));
    } else {
      emit(CommentError(message));
    }
  }

  Future<void> _reloadAndShowWarning(
    int itineraryId,
    String? warningMsg,
  ) async {
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
              warningMessage: warningMsg,
            ),
          );
        }
      },
    );
  }

  @override
  void emit(CommentState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
