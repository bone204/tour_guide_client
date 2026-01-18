import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/restaurant/data/models/create_restaurant_booking_request.dart';
import 'package:tour_guide_app/features/restaurant/domain/usecase/create_restaurant_booking_usecase.dart';
import 'create_restaurant_booking_state.dart';

class CreateRestaurantBookingCubit extends Cubit<CreateRestaurantBookingState> {
  final CreateRestaurantBookingUseCase createRestaurantBookingUseCase;

  CreateRestaurantBookingCubit({required this.createRestaurantBookingUseCase})
    : super(CreateRestaurantBookingInitial());

  Future<void> createBooking(CreateRestaurantBookingRequest request) async {
    emit(CreateRestaurantBookingLoading());

    final result = await createRestaurantBookingUseCase(request);

    if (isClosed) return;

    result.fold(
      (failure) => emit(CreateRestaurantBookingFailure(failure.message)),
      (bookingId) => emit(CreateRestaurantBookingSuccess(bookingId)),
    );
  }
}
