import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_search_response.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_table_search_request.dart';
import 'package:tour_guide_app/features/restaurant/domain/usecase/search_restaurant_tables_usecase.dart';

part 'search_restaurant_tables_state.dart';

class SearchRestaurantTablesCubit extends Cubit<SearchRestaurantTablesState> {
  final SearchRestaurantTablesUseCase searchRestaurantTablesUseCase;

  SearchRestaurantTablesCubit({required this.searchRestaurantTablesUseCase})
    : super(SearchRestaurantTablesState());

  Future<void> searchRestaurants(RestaurantTableSearchRequest request) async {
    emit(state.copyWith(status: SearchRestaurantTablesStatus.loading));

    final result = await searchRestaurantTablesUseCase.call(request);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SearchRestaurantTablesStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (restaurants) => emit(
        state.copyWith(
          status: SearchRestaurantTablesStatus.success,
          restaurants: restaurants,
        ),
      ),
    );
  }
}
