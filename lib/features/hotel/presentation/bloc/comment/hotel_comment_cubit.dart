import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/create_feedback_request.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback_query.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/create_feedback.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/get_feedback.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/check_content.dart';
import 'package:tour_guide_app/features/hotel/presentation/bloc/comment/hotel_comment_state.dart';

class HotelCommentCubit extends Cubit<HotelCommentState> {
  final GetFeedbackUseCase getFeedbackUseCase;
  final CreateFeedbackUseCase createFeedbackUseCase;
  final CheckContentUseCase checkContentUseCase;
  static const int _limit = 10;

  HotelCommentCubit({
    required this.getFeedbackUseCase,
    required this.createFeedbackUseCase,
    required this.checkContentUseCase,
  }) : super(HotelCommentInitial());

  Future<void> loadComments(int hotelId) async {
    if (isClosed) return;
    emit(HotelCommentLoading());

    final query = FeedbackQuery(
      cooperationId: hotelId,
      offset: 0,
      limit: _limit,
    );

    final result = await getFeedbackUseCase(query);

    result.fold(
      (failure) {
        if (!isClosed) emit(HotelCommentError(failure.message));
      },
      (response) {
        if (!isClosed) {
          emit(
            HotelCommentLoaded(
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
    if (state is HotelCommentLoaded) {
      final currentState = state as HotelCommentLoaded;

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

  Future<void> addComment(int hotelId, String content, int star) async {
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
          cooperationId: hotelId,
          comment: content,
        );

        final createResult = await createFeedbackUseCase(request);

        createResult.fold(
          (failure) {
            _emitError(failure.message);
          },
          (success) {
            _reloadAndShowWarning(hotelId, warningMsg);
          },
        );
      },
    );
  }

  void _emitError(String message) {
    if (isClosed) return;
    if (state is HotelCommentLoaded) {
      final currentState = state as HotelCommentLoaded;
      emit(currentState.copyWith(errorMessage: message));
    } else {
      emit(HotelCommentError(message));
    }
  }

  Future<void> _reloadAndShowWarning(int hotelId, String? warningMsg) async {
    if (isClosed) return;
    emit(HotelCommentLoading());

    final query = FeedbackQuery(
      cooperationId: hotelId,
      offset: 0,
      limit: _limit,
    );

    final result = await getFeedbackUseCase(query);

    result.fold(
      (failure) {
        if (!isClosed) emit(HotelCommentError(failure.message));
      },
      (response) {
        if (!isClosed) {
          emit(
            HotelCommentLoaded(
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
  void emit(HotelCommentState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
