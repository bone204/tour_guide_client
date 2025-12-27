part of 'create_rental_bill_cubit.dart';

abstract class CreateRentalBillState extends Equatable {
  const CreateRentalBillState();

  @override
  List<Object> get props => [];
}

class CreateRentalBillInitial extends CreateRentalBillState {}

class CreateRentalBillLoading extends CreateRentalBillState {}

class CreateRentalBillSuccess extends CreateRentalBillState {
  final RentalBill bill;

  const CreateRentalBillSuccess(this.bill);

  @override
  List<Object> get props => [bill];
}

class CreateRentalBillFailure extends CreateRentalBillState {
  final String message;

  const CreateRentalBillFailure(this.message);

  @override
  List<Object> get props => [message];
}
