import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/bills/book_restaurant/data/models/restaurant_booking.dart';

abstract class GetRestaurantBillsState extends Equatable {
  const GetRestaurantBillsState();

  @override
  List<Object> get props => [];
}

class GetRestaurantBillsInitial extends GetRestaurantBillsState {}

class GetRestaurantBillsLoading extends GetRestaurantBillsState {}

class GetRestaurantBillsLoaded extends GetRestaurantBillsState {
  final List<RestaurantBooking> bookings;

  const GetRestaurantBillsLoaded(this.bookings);

  @override
  List<Object> get props => [bookings];
}

class GetRestaurantBillsFailure extends GetRestaurantBillsState {
  final String message;

  const GetRestaurantBillsFailure(this.message);

  @override
  List<Object> get props => [message];
}
