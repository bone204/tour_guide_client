import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback.dart';

enum ReplyStatus { initial, loading, success, failure }

class ReplyState extends Equatable {
  final ReplyStatus status;
  final String? errorMessage;
  final String? warningMessage; // For AI moderation warnings
  final Map<int, List<FeedbackReply>> repliesMap;
  final int? replyingToFeedbackId; // ID of the comment being replied to
  final bool isSubmitting; // Track reply submission state

  const ReplyState({
    this.status = ReplyStatus.initial,
    this.errorMessage,
    this.warningMessage,
    this.repliesMap = const {},
    this.replyingToFeedbackId,
    this.isSubmitting = false,
  });

  ReplyState copyWith({
    ReplyStatus? status,
    String? errorMessage,
    String? warningMessage,
    Map<int, List<FeedbackReply>>? repliesMap,
    int? replyingToFeedbackId,
    bool? isSubmitting,
  }) {
    return ReplyState(
      status: status ?? this.status,
      errorMessage: errorMessage, // Reset if not provided, or logic might vary
      warningMessage: warningMessage,
      repliesMap: repliesMap ?? this.repliesMap,
      replyingToFeedbackId: replyingToFeedbackId ?? this.replyingToFeedbackId,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    warningMessage,
    repliesMap,
    replyingToFeedbackId,
    isSubmitting,
  ];
}
