import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/voucher/data/models/voucher.dart';

abstract class GetVouchersState extends Equatable {
  const GetVouchersState();

  @override
  List<Object> get props => [];
}

class GetVouchersInitial extends GetVouchersState {}

class GetVouchersLoading extends GetVouchersState {}

class GetVouchersLoaded extends GetVouchersState {
  final List<Voucher> vouchers;

  const GetVouchersLoaded(this.vouchers);

  @override
  List<Object> get props => [vouchers];
}

class GetVouchersError extends GetVouchersState {
  final String message;

  const GetVouchersError(this.message);

  @override
  List<Object> get props => [message];
}
