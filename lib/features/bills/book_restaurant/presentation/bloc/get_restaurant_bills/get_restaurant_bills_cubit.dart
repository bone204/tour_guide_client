import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/bills/book_restaurant/domain/usecases/get_restaurant_bookings.dart';
import 'package:tour_guide_app/features/bills/book_restaurant/presentation/bloc/get_restaurant_bills/get_restaurant_bills_state.dart';

class GetRestaurantBillsCubit extends Cubit<GetRestaurantBillsState> {
  final GetRestaurantBookings getRestaurantBookings;

  GetRestaurantBillsCubit({required this.getRestaurantBookings})
    : super(GetRestaurantBillsInitial());

  Future<void> getBookings({String? status}) async {
    emit(GetRestaurantBillsLoading());
    final result = await getRestaurantBookings(status);
    result.fold(
      (failure) => emit(GetRestaurantBillsFailure(failure.message)),
      (bookings) => emit(GetRestaurantBillsLoaded(bookings)),
    );
  }
}
