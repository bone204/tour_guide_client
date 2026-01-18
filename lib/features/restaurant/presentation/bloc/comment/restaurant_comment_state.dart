import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback_query.dart';

abstract class RestaurantCommentState extends Equatable {
  const RestaurantCommentState();

  @override
  List<Object?> get props => [];
}

class RestaurantCommentInitial extends RestaurantCommentState {}

class RestaurantCommentLoading extends RestaurantCommentState {}

class RestaurantCommentLoaded extends RestaurantCommentState {
  final List<Feedback> comments;
  final FeedbackQuery params;
  final bool hasReachedEnd;
  final bool isLoadingMore;
  final bool isSubmitting;
  final String? warningMessage;
  final String? errorMessage;

  const RestaurantCommentLoaded({
    required this.comments,
    required this.params,
    required this.hasReachedEnd,
    this.isLoadingMore = false,
    this.isSubmitting = false,
    this.warningMessage,
    this.errorMessage,
  });

  RestaurantCommentLoaded copyWith({
    List<Feedback>? comments,
    FeedbackQuery? params,
    bool? hasReachedEnd,
    bool? isLoadingMore,
    bool? isSubmitting,
    String? warningMessage,
    String? errorMessage,
  }) {
    return RestaurantCommentLoaded(
      comments: comments ?? this.comments,
      params: params ?? this.params,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      warningMessage: warningMessage ?? this.warningMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    comments,
    params,
    hasReachedEnd,
    isLoadingMore,
    isSubmitting,
    warningMessage,
    errorMessage,
  ];
}

class RestaurantCommentError extends RestaurantCommentState {
  final String message;

  const RestaurantCommentError(this.message);

  @override
  List<Object?> get props => [message];
}
