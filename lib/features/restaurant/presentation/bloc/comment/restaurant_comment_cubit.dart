import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/create_feedback_request.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback_query.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/create_feedback.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/get_feedback.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/check_content.dart';
import 'package:tour_guide_app/features/restaurant/presentation/bloc/comment/restaurant_comment_state.dart';

class RestaurantCommentCubit extends Cubit<RestaurantCommentState> {
  final GetFeedbackUseCase getFeedbackUseCase;
  final CreateFeedbackUseCase createFeedbackUseCase;
  final CheckContentUseCase checkContentUseCase;
  static const int _limit = 10;

  RestaurantCommentCubit({
    required this.getFeedbackUseCase,
    required this.createFeedbackUseCase,
    required this.checkContentUseCase,
  }) : super(RestaurantCommentInitial());

  Future<void> loadComments(int restaurantId) async {
    if (isClosed) return;
    emit(RestaurantCommentLoading());

    final query = FeedbackQuery(
      cooperationId: restaurantId,
      offset: 0,
      limit: _limit,
    );

    final result = await getFeedbackUseCase(query);

    result.fold(
      (failure) {
        if (!isClosed) emit(RestaurantCommentError(failure.message));
      },
      (response) {
        if (!isClosed) {
          emit(
            RestaurantCommentLoaded(
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
    if (state is RestaurantCommentLoaded) {
      final currentState = state as RestaurantCommentLoaded;

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

  Future<void> addComment(int restaurantId, String content, int star) async {
    if (content.trim().length < 5) {
      _emitError('too_short');
      return;
    }

    final checkResult = await checkContentUseCase(content);

    await checkResult.fold(
      (failure) async {
        _emitError(failure.message);
      },
      (checkResponse) async {
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

        final request = CreateFeedbackRequest(
          star: star,
          cooperationId: restaurantId,
          comment: content,
        );

        final createResult = await createFeedbackUseCase(request);

        createResult.fold(
          (failure) {
            _emitError(failure.message);
          },
          (success) {
            _reloadAndShowWarning(restaurantId, warningMsg);
          },
        );
      },
    );
  }

  void _emitError(String message) {
    if (isClosed) return;
    if (state is RestaurantCommentLoaded) {
      final currentState = state as RestaurantCommentLoaded;
      emit(currentState.copyWith(errorMessage: message));
    } else {
      emit(RestaurantCommentError(message));
    }
  }

  Future<void> _reloadAndShowWarning(
    int restaurantId,
    String? warningMsg,
  ) async {
    if (isClosed) return;
    emit(RestaurantCommentLoading());

    final query = FeedbackQuery(
      cooperationId: restaurantId,
      offset: 0,
      limit: _limit,
    );

    final result = await getFeedbackUseCase(query);

    result.fold(
      (failure) {
        if (!isClosed) emit(RestaurantCommentError(failure.message));
      },
      (response) {
        if (!isClosed) {
          emit(
            RestaurantCommentLoaded(
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
  void emit(RestaurantCommentState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
