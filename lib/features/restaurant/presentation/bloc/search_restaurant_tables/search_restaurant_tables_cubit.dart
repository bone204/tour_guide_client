import 'package:bloc/bloc.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_table_search_request.dart';
import 'package:tour_guide_app/features/restaurant/domain/usecase/search_restaurant_tables_usecase.dart';
import 'search_restaurant_tables_state.dart';

class SearchRestaurantTablesCubit extends Cubit<SearchRestaurantTablesState> {
  final SearchRestaurantTablesUseCase searchRestaurantTablesUseCase;

  SearchRestaurantTablesCubit({required this.searchRestaurantTablesUseCase})
    : super(SearchRestaurantTablesInitial());

  Future<void> searchRestaurants(RestaurantTableSearchRequest request) async {
    if (isClosed) return;

    emit(SearchRestaurantTablesLoading());

    final result = await searchRestaurantTablesUseCase(request);

    if (isClosed) return;

    result.fold(
      (failure) =>
          emit(SearchRestaurantTablesFailure(_mapFailureToMessage(failure))),
      (restaurants) => emit(SearchRestaurantTablesSuccess(restaurants)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return "Unexpected Error";
  }
}
