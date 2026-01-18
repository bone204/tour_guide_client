import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/destination_ticket/data/models/destination_bill_model.dart';

abstract class TicketBookingState extends Equatable {
  const TicketBookingState();

  @override
  List<Object?> get props => [];
}

class TicketBookingInitial extends TicketBookingState {}

class TicketBookingLoading extends TicketBookingState {}

class TicketBookingSuccess extends TicketBookingState {
  final DestinationBillModel bill;

  const TicketBookingSuccess(this.bill);

  @override
  List<Object?> get props => [bill];
}

class TicketBookingFailure extends TicketBookingState {
  final String message;

  const TicketBookingFailure(this.message);

  @override
  List<Object?> get props => [message];
}
