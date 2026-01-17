part of 'search_restaurant_tables_cubit.dart';

enum SearchRestaurantTablesStatus { initial, loading, success, failure }

class SearchRestaurantTablesState {
  final SearchRestaurantTablesStatus status;
  final List<RestaurantSearchResponse> restaurants;
  final String? errorMessage;

  const SearchRestaurantTablesState({
    this.status = SearchRestaurantTablesStatus.initial,
    this.restaurants = const [],
    this.errorMessage,
  });

  SearchRestaurantTablesState copyWith({
    SearchRestaurantTablesStatus? status,
    List<RestaurantSearchResponse>? restaurants,
    String? errorMessage,
  }) {
    return SearchRestaurantTablesState(
      status: status ?? this.status,
      restaurants: restaurants ?? this.restaurants,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
