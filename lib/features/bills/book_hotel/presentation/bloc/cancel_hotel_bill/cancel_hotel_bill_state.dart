part of 'cancel_hotel_bill_cubit.dart';

abstract class CancelHotelBillState extends Equatable {
  const CancelHotelBillState();

  @override
  List<Object> get props => [];
}

class CancelHotelBillInitial extends CancelHotelBillState {}

class CancelHotelBillLoading extends CancelHotelBillState {}

class CancelHotelBillSuccess extends CancelHotelBillState {}

class CancelHotelBillFailure extends CancelHotelBillState {
  final String message;

  const CancelHotelBillFailure({required this.message});

  @override
  List<Object> get props => [message];
}
