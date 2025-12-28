import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/voucher/data/models/voucher.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';

enum RentalPaymentStatus { initial, loading, success, failure }

class RentalPaymentState extends Equatable {
  final int? billId;
  final RentalPaymentStatus status;
  final String? errorMessage;
  final String? payUrl; // Added to store payment URL from response
  final PaymentMethod? paymentMethod;
  final Voucher? selectedVoucher;
  final bool useTravelPoints;
  final double totalPrice;
  final double pointDiscount;
  final double voucherDiscount;
  final double finalPrice;
  final String? contactName;
  final String? contactPhone;
  final String? notes;

  const RentalPaymentState({
    this.billId,
    this.status = RentalPaymentStatus.initial,
    this.errorMessage,
    this.payUrl,
    this.paymentMethod,
    this.selectedVoucher,
    this.useTravelPoints = false,
    this.totalPrice = 0,
    this.pointDiscount = 0,
    this.voucherDiscount = 0,
    this.finalPrice = 0,
    this.contactName,
    this.contactPhone,
    this.notes,
  });

  RentalPaymentState copyWith({
    int? billId,
    RentalPaymentStatus? status,
    String? errorMessage,
    String? payUrl,
    PaymentMethod? paymentMethod,
    Voucher? selectedVoucher,
    bool? useTravelPoints,
    double? totalPrice,
    double? pointDiscount,
    double? voucherDiscount,
    double? finalPrice,
    String? contactName,
    String? contactPhone,
    String? notes,
  }) {
    return RentalPaymentState(
      billId: billId ?? this.billId,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      payUrl: payUrl ?? this.payUrl,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      selectedVoucher: selectedVoucher ?? this.selectedVoucher,
      useTravelPoints: useTravelPoints ?? this.useTravelPoints,
      totalPrice: totalPrice ?? this.totalPrice,
      pointDiscount: pointDiscount ?? this.pointDiscount,
      voucherDiscount: voucherDiscount ?? this.voucherDiscount,
      finalPrice: finalPrice ?? this.finalPrice,
      contactName: contactName ?? this.contactName,
      contactPhone: contactPhone ?? this.contactPhone,
      notes: notes ?? this.notes,
    );
  }

  // To allow unselecting voucher if needed, pass null explicitly?
  // copyWith handles null if we change type to Nullable<T> wrapping, but for now standard copyWith.
  // We might need a specific method to clear voucher if needed.

  @override
  List<Object?> get props => [
    billId,
    status,
    errorMessage,
    payUrl,
    paymentMethod,
    selectedVoucher,
    useTravelPoints,
    totalPrice,
    pointDiscount,
    voucherDiscount,
    finalPrice,
    contactName,
    contactPhone,
    notes,
  ];
}
