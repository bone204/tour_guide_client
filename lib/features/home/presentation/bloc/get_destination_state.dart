import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';

abstract class GetDestinationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetDestinationInitial extends GetDestinationState {}

class GetDestinationLoading extends GetDestinationState {}

class GetDestinationLoaded extends GetDestinationState {
  final List<Destination> destinations;
  final DestinationQuery params;
  final bool hasReachedEnd;
  final bool isLoadingMore;

  GetDestinationLoaded({
    required this.destinations,
    required this.params,
    required this.hasReachedEnd,
    this.isLoadingMore = false,
  });

  GetDestinationLoaded copyWith({
    List<Destination>? destinations,
    DestinationQuery? params,
    bool? hasReachedEnd,
    bool? isLoadingMore,
  }) {
    return GetDestinationLoaded(
      destinations: destinations ?? this.destinations,
      params: params ?? this.params,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [destinations, params, hasReachedEnd, isLoadingMore];
}

class GetDestinationError extends GetDestinationState {
  final String message;

  GetDestinationError(this.message);

  @override
  List<Object?> get props => [message];
}
