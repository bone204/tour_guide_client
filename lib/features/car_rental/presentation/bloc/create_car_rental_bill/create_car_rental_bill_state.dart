part of 'create_car_rental_bill_cubit.dart';

abstract class CreateCarRentalBillState extends Equatable {
  const CreateCarRentalBillState();

  @override
  List<Object> get props => [];
}

class CreateCarRentalBillInitial extends CreateCarRentalBillState {}

class CreateCarRentalBillLoading extends CreateCarRentalBillState {}

class CreateCarRentalBillSuccess extends CreateCarRentalBillState {
  final RentalBill bill;

  const CreateCarRentalBillSuccess(this.bill);

  @override
  List<Object> get props => [bill];
}

class CreateCarRentalBillFailure extends CreateCarRentalBillState {
  final String message;

  const CreateCarRentalBillFailure(this.message);

  @override
  List<Object> get props => [message];
}
