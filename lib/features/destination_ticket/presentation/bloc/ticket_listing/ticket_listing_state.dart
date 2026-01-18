import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';

abstract class TicketListingState extends Equatable {
  const TicketListingState();

  @override
  List<Object?> get props => [];
}

class TicketListingInitial extends TicketListingState {}

class TicketListingLoading extends TicketListingState {}

class TicketListingSuccess extends TicketListingState {
  final List<Destination> destinations;

  const TicketListingSuccess(this.destinations);

  @override
  List<Object?> get props => [destinations];
}

class TicketListingFailure extends TicketListingState {
  final String message;

  const TicketListingFailure(this.message);

  @override
  List<Object?> get props => [message];
}
