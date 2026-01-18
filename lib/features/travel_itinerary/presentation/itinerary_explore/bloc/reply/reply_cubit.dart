import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/core/services/feedback/domain/repositories/feedback_repository.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/create_feedback_reply.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/get_feedback_replies.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/reply/reply_state.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback.dart';

class ReplyCubit extends Cubit<ReplyState> {
  final FeedbackRepository feedbackRepository;
  final GetFeedbackRepliesUseCase getFeedbackRepliesUseCase;
  final CreateFeedbackReplyUseCase createFeedbackReplyUseCase;

  ReplyCubit({
    required this.feedbackRepository,
    required this.getFeedbackRepliesUseCase,
    required this.createFeedbackReplyUseCase,
  }) : super(const ReplyState());

  Future<void> loadReplies(int feedbackId) async {
    // Optional: Avoid reloading if already loaded for this ID?
    // For simplicity, we just load.
    emit(
      state.copyWith(status: ReplyStatus.loading),
    ); // Enable loading state for shimmer

    final result = await getFeedbackRepliesUseCase(feedbackId);
    result.fold(
      (failure) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: ReplyStatus.failure,
              errorMessage: failure.message,
            ),
          );
        }
      },
      (response) {
        if (!isClosed) {
          final updatedMap = Map<int, List<FeedbackReply>>.from(
            state.repliesMap,
          );
          updatedMap[feedbackId] = response.items;
          emit(
            state.copyWith(status: ReplyStatus.success, repliesMap: updatedMap),
          );
        }
      },
    );
  }

  // Refactoring plan: simple create first, then refine state.

  Future<void> checkContentAndReply(int feedbackId, String content) async {
    if (content.trim().isEmpty) return;

    // Set isSubmitting to true at start
    if (!isClosed) emit(state.copyWith(isSubmitting: true));

    // 1. Check Content
    final checkResult = await feedbackRepository.checkContent(content);

    await checkResult.fold(
      (failure) async {
        if (!isClosed)
          emit(
            state.copyWith(
              status: ReplyStatus.failure,
              errorMessage: failure.message,
              isSubmitting: false,
            ),
          );
      },
      (checkResponse) async {
        if (checkResponse.decision == 'reject') {
          if (!isClosed) {
            final reasons = checkResponse.reasons ?? [];
            final localizedReasons =
                reasons.isNotEmpty ? reasons.join(',') : 'rule_reject';
            emit(
              state.copyWith(
                status: ReplyStatus.failure,
                errorMessage: 'feedbackContentRejected:$localizedReasons',
                isSubmitting: false,
              ),
            );
          }
        } else {
          // 2. Create Reply
          final createResult = await createFeedbackReplyUseCase(
            CreateFeedbackReplyParams(feedbackId: feedbackId, content: content),
          );

          createResult.fold(
            (failure) {
              if (!isClosed)
                emit(
                  state.copyWith(
                    status: ReplyStatus.failure,
                    errorMessage: failure.message,
                    isSubmitting: false,
                  ),
                );
            },
            (success) {
              if (!isClosed) {
                emit(
                  state.copyWith(
                    status: ReplyStatus.success,
                    isSubmitting: false,
                  ),
                );
                // Reload replies for this feedback
                loadReplies(feedbackId);
              }
            },
          );
        }
      },
    );
  }
}
