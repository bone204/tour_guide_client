part of 'get_draft_itineraries_cubit.dart';

abstract class GetDraftItinerariesState extends Equatable {
  const GetDraftItinerariesState();

  @override
  List<Object> get props => [];
}

class GetDraftItinerariesInitial extends GetDraftItinerariesState {}

class GetDraftItinerariesLoading extends GetDraftItinerariesState {}

class GetDraftItinerariesSuccess extends GetDraftItinerariesState {
  final List<Itinerary> itineraries;

  const GetDraftItinerariesSuccess(this.itineraries);

  @override
  List<Object> get props => [itineraries];
}

class GetDraftItinerariesFailure extends GetDraftItinerariesState {
  final String message;

  const GetDraftItinerariesFailure(this.message);

  @override
  List<Object> get props => [message];
}
