import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/bills/book_restaurant/domain/usecases/get_restaurant_booking_detail.dart';
import 'package:tour_guide_app/features/bills/book_restaurant/presentation/bloc/get_restaurant_bill_detail/get_restaurant_bill_detail_state.dart';

class GetRestaurantBillDetailCubit extends Cubit<GetRestaurantBillDetailState> {
  final GetRestaurantBookingDetail getRestaurantBookingDetail;

  GetRestaurantBillDetailCubit({required this.getRestaurantBookingDetail})
    : super(GetRestaurantBillDetailInitial());

  Future<void> getBookingDetail(int id) async {
    emit(GetRestaurantBillDetailLoading());
    final result = await getRestaurantBookingDetail(id);
    result.fold(
      (failure) => emit(GetRestaurantBillDetailFailure(failure.message)),
      (booking) => emit(GetRestaurantBillDetailLoaded(booking)),
    );
  }
}
