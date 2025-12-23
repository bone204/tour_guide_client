import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';

abstract class GetFavoritesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetFavoritesInitial extends GetFavoritesState {}

class GetFavoritesLoading extends GetFavoritesState {}

class GetFavoritesLoaded extends GetFavoritesState {
  final List<Destination> destinations;

  GetFavoritesLoaded({
    required this.destinations,
  });

  @override
  List<Object?> get props => [destinations];
}

class GetFavoritesError extends GetFavoritesState {
  final String message;

  GetFavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}

