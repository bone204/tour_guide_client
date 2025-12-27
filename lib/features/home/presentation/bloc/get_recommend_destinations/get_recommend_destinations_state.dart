import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';

abstract class GetRecommendDestinationsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetRecommendDestinationsInitial extends GetRecommendDestinationsState {}

class GetRecommendDestinationsLoading extends GetRecommendDestinationsState {}

class GetRecommendDestinationsLoaded extends GetRecommendDestinationsState {
  final List<Destination> destinations;
  final DestinationQuery params;
  final bool hasReachedEnd;
  final bool isLoadingMore;

  GetRecommendDestinationsLoaded({
    required this.destinations,
    required this.params,
    required this.hasReachedEnd,
    this.isLoadingMore = false,
  });

  GetRecommendDestinationsLoaded copyWith({
    List<Destination>? destinations,
    DestinationQuery? params,
    bool? hasReachedEnd,
    bool? isLoadingMore,
  }) {
    return GetRecommendDestinationsLoaded(
      destinations: destinations ?? this.destinations,
      params: params ?? this.params,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    destinations,
    params,
    hasReachedEnd,
    isLoadingMore,
  ];
}

class GetRecommendDestinationsError extends GetRecommendDestinationsState {
  final String message;

  GetRecommendDestinationsError(this.message);

  @override
  List<Object?> get props => [message];
}
