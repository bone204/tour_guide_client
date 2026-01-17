part of 'book_hotel_workflow_cubit.dart';

abstract class BookHotelWorkflowState extends Equatable {
  const BookHotelWorkflowState();

  @override
  List<Object> get props => [];
}

class BookHotelWorkflowInitial extends BookHotelWorkflowState {}

class BookHotelWorkflowLoading extends BookHotelWorkflowState {}

class BookHotelWorkflowSuccess extends BookHotelWorkflowState {
  final HotelBill bill;

  const BookHotelWorkflowSuccess(this.bill);

  @override
  List<Object> get props => [bill];
}

class BookHotelWorkflowFailure extends BookHotelWorkflowState {
  final String message;

  const BookHotelWorkflowFailure(this.message);

  @override
  List<Object> get props => [message];
}
