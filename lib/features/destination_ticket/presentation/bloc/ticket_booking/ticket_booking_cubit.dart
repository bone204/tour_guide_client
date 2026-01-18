import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/destination_ticket/data/models/create_destination_bill_request.dart';
import 'package:tour_guide_app/features/destination_ticket/domain/repository/destination_ticket_repository.dart';
import 'package:tour_guide_app/features/destination_ticket/presentation/bloc/ticket_booking/ticket_booking_state.dart';

class TicketBookingCubit extends Cubit<TicketBookingState> {
  final DestinationTicketRepository _repository;

  TicketBookingCubit(this._repository) : super(TicketBookingInitial());

  Future<void> createBooking(CreateDestinationBillRequest request) async {
    emit(TicketBookingLoading());
    final result = await _repository.createBill(request);
    result.fold(
      (failure) => emit(TicketBookingFailure(failure.message)),
      (bill) => emit(TicketBookingSuccess(bill)),
    );
  }
}
