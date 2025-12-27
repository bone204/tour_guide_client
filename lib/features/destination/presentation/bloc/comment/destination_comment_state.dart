import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback_query.dart';

abstract class DestinationCommentState extends Equatable {
  const DestinationCommentState();

  @override
  List<Object?> get props => [];
}

class DestinationCommentInitial extends DestinationCommentState {}

class DestinationCommentLoading extends DestinationCommentState {}

class DestinationCommentLoaded extends DestinationCommentState {
  final List<Feedback> comments;
  final FeedbackQuery params;
  final bool hasReachedEnd;
  final bool isLoadingMore;
  final String? warningMessage;
  final String? errorMessage;

  const DestinationCommentLoaded({
    required this.comments,
    required this.params,
    required this.hasReachedEnd,
    this.isLoadingMore = false,
    this.warningMessage,
    this.errorMessage,
  });

  DestinationCommentLoaded copyWith({
    List<Feedback>? comments,
    FeedbackQuery? params,
    bool? hasReachedEnd,
    bool? isLoadingMore,
    String? warningMessage,
    String? errorMessage,
  }) {
    return DestinationCommentLoaded(
      comments: comments ?? this.comments,
      params: params ?? this.params,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      warningMessage: warningMessage ?? this.warningMessage,
      errorMessage: errorMessage, // Do not preserve error message by default
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

class DestinationCommentError extends DestinationCommentState {
  final String message;

  const DestinationCommentError(this.message);

  @override
  List<Object?> get props => [message];
}
