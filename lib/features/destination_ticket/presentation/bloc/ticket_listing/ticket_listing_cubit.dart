import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';
import 'package:tour_guide_app/features/destination_ticket/domain/repository/destination_ticket_repository.dart';
import 'package:tour_guide_app/features/destination_ticket/presentation/bloc/ticket_listing/ticket_listing_state.dart';

class TicketListingCubit extends Cubit<TicketListingState> {
  final DestinationTicketRepository _repository;

  TicketListingCubit(this._repository) : super(TicketListingInitial());

  Future<void> getTickets({String? province, String? q}) async {
    emit(TicketListingLoading());
    final result = await _repository.getTicketableDestinations(
      DestinationQuery(province: province, q: q, limit: 100),
    );
    result.fold(
      (failure) => emit(TicketListingFailure(failure.message)),
      (response) => emit(TicketListingSuccess(response.items)),
    );
  }
}
