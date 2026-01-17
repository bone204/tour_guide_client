part of 'hotel_payment_cubit.dart';

enum HotelPaymentStatus { initial, loading, success, failure }

class HotelPaymentState extends Equatable {
  final HotelPaymentStatus status;
  final HotelBill? bill;
  final String? errorMessage;
  final int? billId;
  final String? contactName;
  final String? contactPhone;
  final String? notes;

  const HotelPaymentState({
    this.status = HotelPaymentStatus.initial,
    this.bill,
    this.errorMessage,
    this.billId,
    this.contactName,
    this.contactPhone,
    this.notes,
  });

  HotelPaymentState copyWith({
    HotelPaymentStatus? status,
    HotelBill? bill,
    String? errorMessage,
    int? billId,
    String? contactName,
    String? contactPhone,
    String? notes,
  }) {
    return HotelPaymentState(
      status: status ?? this.status,
      bill: bill ?? this.bill,
      errorMessage: errorMessage ?? this.errorMessage,
      billId: billId ?? this.billId,
      contactName: contactName ?? this.contactName,
      contactPhone: contactPhone ?? this.contactPhone,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    status,
    bill,
    errorMessage,
    billId,
    contactName,
    contactPhone,
    notes,
  ];
}
