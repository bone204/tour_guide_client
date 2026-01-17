import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_search_response.dart';

abstract class SearchRestaurantTablesState extends Equatable {
  const SearchRestaurantTablesState();

  @override
  List<Object> get props => [];
}

class SearchRestaurantTablesInitial extends SearchRestaurantTablesState {}

class SearchRestaurantTablesLoading extends SearchRestaurantTablesState {}

class SearchRestaurantTablesSuccess extends SearchRestaurantTablesState {
  final List<RestaurantSearchResponse> restaurants;

  const SearchRestaurantTablesSuccess(this.restaurants);

  @override
  List<Object> get props => [restaurants];
}

class SearchRestaurantTablesFailure extends SearchRestaurantTablesState {
  final String message;

  const SearchRestaurantTablesFailure(this.message);

  @override
  List<Object> get props => [message];
}
