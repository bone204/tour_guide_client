import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_search_response.dart';

abstract class RestaurantListState extends Equatable {
  const RestaurantListState();

  @override
  List<Object> get props => [];
}

class RestaurantListInitial extends RestaurantListState {}

class RestaurantListLoading extends RestaurantListState {}

class RestaurantListLoaded extends RestaurantListState {
  final List<RestaurantSearchResponse> restaurants;

  const RestaurantListLoaded(this.restaurants);

  @override
  List<Object> get props => [restaurants];
}

class RestaurantListError extends RestaurantListState {
  final String message;

  const RestaurantListError(this.message);

  @override
  List<Object> get props => [message];
}
