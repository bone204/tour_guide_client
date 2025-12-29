import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/create_feedback_request.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback_query.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/create_feedback.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/get_feedback.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/check_content.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/comment/cooperation_comment_state.dart';

class CooperationCommentCubit extends Cubit<CooperationCommentState> {
  final GetFeedbackUseCase getFeedbackUseCase;
  final CreateFeedbackUseCase createFeedbackUseCase;
  final CheckContentUseCase checkContentUseCase;
  static const int _limit = 10;

  CooperationCommentCubit({
    required this.getFeedbackUseCase,
    required this.createFeedbackUseCase,
    required this.checkContentUseCase,
  }) : super(CooperationCommentInitial());

  Future<void> loadComments(int cooperationId) async {
    if (isClosed) return;
    emit(CooperationCommentLoading());

    final query = FeedbackQuery(
      cooperationId: cooperationId,
      offset: 0,
      limit: _limit,
    );

    final result = await getFeedbackUseCase(query);

    result.fold(
      (failure) {
        if (!isClosed) emit(CooperationCommentError(failure.message));
      },
      (response) {
        if (!isClosed) {
          emit(
            CooperationCommentLoaded(
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
    if (state is CooperationCommentLoaded) {
      final currentState = state as CooperationCommentLoaded;

      if (currentState.hasReachedEnd || currentState.isLoadingMore) return;

      if (!isClosed) emit(currentState.copyWith(isLoadingMore: true));

      final nextOffset = (currentState.params.offset ?? 0) + _limit;
      final nextParams = FeedbackQuery(
        cooperationId: currentState.params.cooperationId,
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

  Future<void> addComment(int cooperationId, String content, int star) async {
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
          cooperationId: cooperationId,
          comment: content,
        );

        final createResult = await createFeedbackUseCase(request);

        createResult.fold(
          (failure) {
            _emitError(failure.message);
          },
          (success) {
            _reloadAndShowWarning(cooperationId, warningMsg);
          },
        );
      },
    );
  }

  void _emitError(String message) {
    if (isClosed) return;
    if (state is CooperationCommentLoaded) {
      final currentState = state as CooperationCommentLoaded;
      emit(currentState.copyWith(errorMessage: message));
    } else {
      emit(CooperationCommentError(message));
    }
  }

  Future<void> _reloadAndShowWarning(
    int cooperationId,
    String? warningMsg,
  ) async {
    if (isClosed) return;
    emit(CooperationCommentLoading());

    final query = FeedbackQuery(
      cooperationId: cooperationId,
      offset: 0,
      limit: _limit,
    );

    final result = await getFeedbackUseCase(query);

    result.fold(
      (failure) {
        if (!isClosed) emit(CooperationCommentError(failure.message));
      },
      (response) {
        if (!isClosed) {
          emit(
            CooperationCommentLoaded(
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
  void emit(CooperationCommentState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
