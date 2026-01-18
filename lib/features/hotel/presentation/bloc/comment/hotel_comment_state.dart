import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback_query.dart';

abstract class HotelCommentState extends Equatable {
  const HotelCommentState();

  @override
  List<Object?> get props => [];
}

class HotelCommentInitial extends HotelCommentState {}

class HotelCommentLoading extends HotelCommentState {}

class HotelCommentLoaded extends HotelCommentState {
  final List<Feedback> comments;
  final FeedbackQuery params;
  final bool hasReachedEnd;
  final bool isLoadingMore;
  final String? warningMessage;
  final String? errorMessage;

  const HotelCommentLoaded({
    required this.comments,
    required this.params,
    required this.hasReachedEnd,
    this.isLoadingMore = false,
    this.warningMessage,
    this.errorMessage,
  });

  HotelCommentLoaded copyWith({
    List<Feedback>? comments,
    FeedbackQuery? params,
    bool? hasReachedEnd,
    bool? isLoadingMore,
    String? warningMessage,
    String? errorMessage,
  }) {
    return HotelCommentLoaded(
      comments: comments ?? this.comments,
      params: params ?? this.params,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
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
    warningMessage,
    errorMessage,
  ];
}

class HotelCommentError extends HotelCommentState {
  final String message;

  const HotelCommentError(this.message);

  @override
  List<Object?> get props => [message];
}
