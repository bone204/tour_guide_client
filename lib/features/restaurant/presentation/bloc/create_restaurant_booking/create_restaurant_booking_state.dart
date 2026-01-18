import 'package:equatable/equatable.dart';

abstract class CreateRestaurantBookingState extends Equatable {
  const CreateRestaurantBookingState();

  @override
  List<Object> get props => [];
}

class CreateRestaurantBookingInitial extends CreateRestaurantBookingState {}

class CreateRestaurantBookingLoading extends CreateRestaurantBookingState {}

class CreateRestaurantBookingSuccess extends CreateRestaurantBookingState {
  final int bookingId;

  const CreateRestaurantBookingSuccess(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

class CreateRestaurantBookingFailure extends CreateRestaurantBookingState {
  final String message;

  const CreateRestaurantBookingFailure(this.message);

  @override
  List<Object> get props => [message];
}
