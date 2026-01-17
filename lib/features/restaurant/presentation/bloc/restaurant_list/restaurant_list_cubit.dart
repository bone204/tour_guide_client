import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_table_search_request.dart';
import 'package:tour_guide_app/features/restaurant/domain/usecase/search_restaurant_tables_usecase.dart';
import 'package:tour_guide_app/features/restaurant/presentation/bloc/restaurant_list/restaurant_list_state.dart';

class RestaurantListCubit extends Cubit<RestaurantListState> {
  final SearchRestaurantTablesUseCase searchRestaurantTablesUseCase;

  RestaurantListCubit({required this.searchRestaurantTablesUseCase})
    : super(RestaurantListInitial());

  Future<void> getRestaurants() async {
    if (isClosed) return;
    emit(RestaurantListLoading());

    final result = await searchRestaurantTablesUseCase(
      RestaurantTableSearchRequest(),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(RestaurantListError(failure.message)),
      (data) => emit(RestaurantListLoaded(data)),
    );
  }
}
