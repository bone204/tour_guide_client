import 'package:equatable/equatable.dart';

abstract class LikeItineraryState extends Equatable {
  const LikeItineraryState();

  @override
  List<Object> get props => [];
}

class LikeItineraryInitial extends LikeItineraryState {}

class LikeItineraryUpdate extends LikeItineraryState {
  final int itineraryId;
  final bool isLiked;
  final int likeCount;

  const LikeItineraryUpdate({
    required this.itineraryId,
    required this.isLiked,
    required this.likeCount,
  });

  @override
  List<Object> get props => [itineraryId, isLiked, likeCount];
}

class LikeItineraryFailure extends LikeItineraryState {
  final String message;

  const LikeItineraryFailure({required this.message});

  @override
  List<Object> get props => [message];
}
