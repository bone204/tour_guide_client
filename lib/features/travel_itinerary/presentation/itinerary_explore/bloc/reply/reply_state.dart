import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback.dart';

enum ReplyStatus { initial, loading, success, failure }

class ReplyState extends Equatable {
  final ReplyStatus status;
  final String? errorMessage;
  final String? warningMessage; // For AI moderation warnings
  final Map<int, List<FeedbackReply>> repliesMap;
  final int? replyingToFeedbackId; // ID of the comment being replied to

  const ReplyState({
    this.status = ReplyStatus.initial,
    this.errorMessage,
    this.warningMessage,
    this.repliesMap = const {},
    this.replyingToFeedbackId,
  });

  ReplyState copyWith({
    ReplyStatus? status,
    String? errorMessage,
    String? warningMessage,
    Map<int, List<FeedbackReply>>? repliesMap,
    int? replyingToFeedbackId,
  }) {
    return ReplyState(
      status: status ?? this.status,
      errorMessage: errorMessage, // Reset if not provided, or logic might vary
      warningMessage: warningMessage,
      repliesMap: repliesMap ?? this.repliesMap,
      replyingToFeedbackId: replyingToFeedbackId ?? this.replyingToFeedbackId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    warningMessage,
    repliesMap,
    replyingToFeedbackId,
  ];
}
