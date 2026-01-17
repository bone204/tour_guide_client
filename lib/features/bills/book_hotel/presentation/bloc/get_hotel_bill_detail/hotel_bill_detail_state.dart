part of 'get_hotel_bill_detail_cubit.dart';

enum HotelBillDetailInitStatus { initial, loading, success, failure }

class HotelBillDetailState extends Equatable {
  final HotelBillDetailInitStatus status;
  final HotelBill? bill;
  final String? errorMessage;

  const HotelBillDetailState({
    this.status = HotelBillDetailInitStatus.initial,
    this.bill,
    this.errorMessage,
  });

  HotelBillDetailState copyWith({
    HotelBillDetailInitStatus? status,
    HotelBill? bill,
    String? errorMessage,
  }) {
    return HotelBillDetailState(
      status: status ?? this.status,
      bill: bill ?? this.bill,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, bill, errorMessage];
}
