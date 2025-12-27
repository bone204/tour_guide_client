import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';

enum RentalBillDetailInitStatus { initial, loading, success, failure }

class RentalBillDetailState extends Equatable {
  final RentalBillDetailInitStatus status;
  final RentalBill? bill;
  final String? errorMessage;

  const RentalBillDetailState({
    this.status = RentalBillDetailInitStatus.initial,
    this.bill,
    this.errorMessage,
  });

  RentalBillDetailState copyWith({
    RentalBillDetailInitStatus? status,
    RentalBill? bill,
    String? errorMessage,
  }) {
    return RentalBillDetailState(
      status: status ?? this.status,
      bill: bill ?? this.bill,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, bill, errorMessage];
}
