import 'package:equatable/equatable.dart';

abstract class CreateHotelBillState extends Equatable {
  const CreateHotelBillState();

  @override
  List<Object> get props => [];
}

class CreateHotelBillInitial extends CreateHotelBillState {}

class CreateHotelBillLoading extends CreateHotelBillState {}

class CreateHotelBillSuccess extends CreateHotelBillState {
  final int billId;

  const CreateHotelBillSuccess(this.billId);

  @override
  List<Object> get props => [billId];
}

class CreateHotelBillFailure extends CreateHotelBillState {
  final String message;

  const CreateHotelBillFailure(this.message);

  @override
  List<Object> get props => [message];
}
