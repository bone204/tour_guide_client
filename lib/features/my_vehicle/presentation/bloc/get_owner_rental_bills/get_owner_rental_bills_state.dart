import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';

enum GetOwnerRentalBillsStatus { initial, loading, loaded, error }

class GetOwnerRentalBillsState extends Equatable {
  final GetOwnerRentalBillsStatus status;
  final List<RentalBill> bills;
  final String? message;

  const GetOwnerRentalBillsState({
    this.status = GetOwnerRentalBillsStatus.initial,
    this.bills = const [],
    this.message,
  });

  GetOwnerRentalBillsState copyWith({
    GetOwnerRentalBillsStatus? status,
    List<RentalBill>? bills,
    String? message,
  }) {
    return GetOwnerRentalBillsState(
      status: status ?? this.status,
      bills: bills ?? this.bills,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, bills, message];
}
