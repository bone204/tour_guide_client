import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/create_feedback_request.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback_query.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/create_feedback.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/get_feedback.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/check_content.dart';
import 'package:tour_guide_app/features/destination/presentation/bloc/comment/destination_comment_state.dart';

class DestinationCommentCubit extends Cubit<DestinationCommentState> {
  final GetFeedbackUseCase getFeedbackUseCase;
  final CreateFeedbackUseCase createFeedbackUseCase;
  final CheckContentUseCase checkContentUseCase;
  static const int _limit = 10;

  DestinationCommentCubit({
    required this.getFeedbackUseCase,
    required this.createFeedbackUseCase,
    required this.checkContentUseCase,
  }) : super(DestinationCommentInitial());

  Future<void> loadComments(int destinationId) async {
    if (isClosed) return;
    emit(DestinationCommentLoading());

    final query = FeedbackQuery(
      destinationId: destinationId,
      offset: 0,
      limit: _limit,
    );

    final result = await getFeedbackUseCase(query);

    result.fold(
      (failure) {
        if (!isClosed) emit(DestinationCommentError(failure.message));
      },
      (response) {
        if (!isClosed) {
          emit(
            DestinationCommentLoaded(
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
    if (state is DestinationCommentLoaded) {
      final currentState = state as DestinationCommentLoaded;

      if (currentState.hasReachedEnd || currentState.isLoadingMore) return;

      if (!isClosed) emit(currentState.copyWith(isLoadingMore: true));

      final nextOffset = (currentState.params.offset ?? 0) + _limit;
      final nextParams = FeedbackQuery(
        destinationId: currentState.params.destinationId,
        offset: nextOffset,
        limit: _limit,
      );

      final result = await getFeedbackUseCase(nextParams);

      result.fold(
        (failure) {
          if (!isClosed) emit(currentState.copyWith(isLoadingMore: false));
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

  Future<void> addComment(int destinationId, String content, int star) async {
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
          star: star,
          destinationId: destinationId,
          comment: content,
        );

        final createResult = await createFeedbackUseCase(request);

        createResult.fold(
          (failure) {
            _emitError(failure.message);
          },
          (success) {
            _reloadAndShowWarning(destinationId, warningMsg);
          },
        );
      },
    );
  }

  void _emitError(String message) {
    if (isClosed) return;
    if (state is DestinationCommentLoaded) {
      final currentState = state as DestinationCommentLoaded;
      emit(currentState.copyWith(errorMessage: message));
    } else {
      emit(DestinationCommentError(message));
    }
  }

  Future<void> _reloadAndShowWarning(
    int destinationId,
    String? warningMsg,
  ) async {
    if (isClosed) return;
    emit(DestinationCommentLoading());

    final query = FeedbackQuery(
      destinationId: destinationId,
      offset: 0,
      limit: _limit,
    );

    final result = await getFeedbackUseCase(query);

    result.fold(
      (failure) {
        if (!isClosed) emit(DestinationCommentError(failure.message));
      },
      (response) {
        if (!isClosed) {
          emit(
            DestinationCommentLoaded(
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
}
