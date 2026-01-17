part of 'get_hotel_bill_detail_cubit.dart';

abstract class GetHotelBillDetailState extends Equatable {
  const GetHotelBillDetailState();

  @override
  List<Object> get props => [];
}

class GetHotelBillDetailInitial extends GetHotelBillDetailState {}

class GetHotelBillDetailLoading extends GetHotelBillDetailState {}

class GetHotelBillDetailSuccess extends GetHotelBillDetailState {
  final HotelBill bill;

  const GetHotelBillDetailSuccess(this.bill);

  @override
  List<Object> get props => [bill];
}

class GetHotelBillDetailFailure extends GetHotelBillDetailState {
  final String message;

  const GetHotelBillDetailFailure(this.message);

  @override
  List<Object> get props => [message];
}
