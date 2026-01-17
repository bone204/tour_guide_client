import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel.dart';

abstract class HotelRoomsSearchState extends Equatable {
  const HotelRoomsSearchState();

  @override
  List<Object?> get props => [];
}

class HotelRoomsSearchInitial extends HotelRoomsSearchState {}

class HotelRoomsSearchLoading extends HotelRoomsSearchState {}

class HotelRoomsSearchSuccess extends HotelRoomsSearchState {
  final List<Hotel> hotels;

  const HotelRoomsSearchSuccess(this.hotels);

  @override
  List<Object?> get props => [hotels];
}

class HotelRoomsSearchFailure extends HotelRoomsSearchState {
  final String message;

  const HotelRoomsSearchFailure(this.message);

  @override
  List<Object?> get props => [message];
}
