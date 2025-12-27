import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';

enum RentalBillListStatus { initial, loading, success, failure }

class RentalBillListState extends Equatable {
  final RentalBillListStatus status;
  final List<RentalBill> bills;
  final String? errorMessage;
  final RentalBillStatus? filterStatus;

  const RentalBillListState({
    this.status = RentalBillListStatus.initial,
    this.bills = const [],
    this.errorMessage,
    this.filterStatus,
  });

  RentalBillListState copyWith({
    RentalBillListStatus? status,
    List<RentalBill>? bills,
    String? errorMessage,
    RentalBillStatus? filterStatus,
  }) {
    return RentalBillListState(
      status: status ?? this.status,
      bills: bills ?? this.bills,
      errorMessage: errorMessage ?? this.errorMessage,
      filterStatus: filterStatus ?? this.filterStatus,
    );
  }

  @override
  List<Object?> get props => [status, bills, errorMessage, filterStatus];
}
