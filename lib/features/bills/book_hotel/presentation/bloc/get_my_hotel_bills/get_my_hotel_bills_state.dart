part of 'get_my_hotel_bills_cubit.dart';

abstract class GetMyHotelBillsState extends Equatable {
  const GetMyHotelBillsState();

  @override
  List<Object> get props => [];
}

class GetMyHotelBillsInitial extends GetMyHotelBillsState {}

class GetMyHotelBillsLoading extends GetMyHotelBillsState {}

class GetMyHotelBillsSuccess extends GetMyHotelBillsState {
  final List<HotelBill> bills;

  const GetMyHotelBillsSuccess(this.bills);

  @override
  List<Object> get props => [bills];
}

class GetMyHotelBillsFailure extends GetMyHotelBillsState {
  final String message;

  const GetMyHotelBillsFailure(this.message);

  @override
  List<Object> get props => [message];
}
