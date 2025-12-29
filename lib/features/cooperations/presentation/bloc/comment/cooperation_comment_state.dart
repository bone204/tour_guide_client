import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback_query.dart';

abstract class CooperationCommentState extends Equatable {
  const CooperationCommentState();

  @override
  List<Object?> get props => [];
}

class CooperationCommentInitial extends CooperationCommentState {}

class CooperationCommentLoading extends CooperationCommentState {}

class CooperationCommentLoaded extends CooperationCommentState {
  final List<Feedback> comments;
  final FeedbackQuery params;
  final bool hasReachedEnd;
  final bool isLoadingMore;
  final String? warningMessage;
  final String? errorMessage;

  const CooperationCommentLoaded({
    required this.comments,
    required this.params,
    this.hasReachedEnd = false,
    this.isLoadingMore = false,
    this.warningMessage,
    this.errorMessage,
  });

  CooperationCommentLoaded copyWith({
    List<Feedback>? comments,
    FeedbackQuery? params,
    bool? hasReachedEnd,
    bool? isLoadingMore,
    String? warningMessage,
    String? errorMessage,
  }) {
    return CooperationCommentLoaded(
      comments: comments ?? this.comments,
      params: params ?? this.params,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      warningMessage: warningMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    comments,
    params,
    hasReachedEnd,
    isLoadingMore,
    warningMessage,
    errorMessage,
  ];
}

class CooperationCommentError extends CooperationCommentState {
  final String message;

  const CooperationCommentError(this.message);

  @override
  List<Object?> get props => [message];
}
