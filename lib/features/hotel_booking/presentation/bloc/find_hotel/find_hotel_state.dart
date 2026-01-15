import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel.dart';

abstract class FindHotelState extends Equatable {
  const FindHotelState();

  @override
  List<Object> get props => [];
}

class FindHotelInitial extends FindHotelState {}

class FindHotelLoading extends FindHotelState {}

class FindHotelSuccess extends FindHotelState {
  final List<Hotel> hotels;

  const FindHotelSuccess(this.hotels);

  @override
  List<Object> get props => [hotels];
}

class FindHotelFailure extends FindHotelState {
  final String message;

  const FindHotelFailure(this.message);

  @override
  List<Object> get props => [message];
}
