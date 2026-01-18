import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/bills/book_restaurant/data/models/restaurant_booking.dart';

abstract class GetRestaurantBillDetailState extends Equatable {
  const GetRestaurantBillDetailState();

  @override
  List<Object> get props => [];
}

class GetRestaurantBillDetailInitial extends GetRestaurantBillDetailState {}

class GetRestaurantBillDetailLoading extends GetRestaurantBillDetailState {}

class GetRestaurantBillDetailLoaded extends GetRestaurantBillDetailState {
  final RestaurantBooking booking;

  const GetRestaurantBillDetailLoaded(this.booking);

  @override
  List<Object> get props => [booking];
}

class GetRestaurantBillDetailFailure extends GetRestaurantBillDetailState {
  final String message;

  const GetRestaurantBillDetailFailure(this.message);

  @override
  List<Object> get props => [message];
}
