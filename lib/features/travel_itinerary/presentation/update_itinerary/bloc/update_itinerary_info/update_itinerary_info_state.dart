part of 'update_itinerary_info_cubit.dart';

abstract class UpdateItineraryInfoState extends Equatable {
  const UpdateItineraryInfoState();

  @override
  List<Object> get props => [];
}

class UpdateItineraryInfoInitial extends UpdateItineraryInfoState {}

class UpdateItineraryInfoLoading extends UpdateItineraryInfoState {}

class UpdateItineraryInfoSuccess extends UpdateItineraryInfoState {
  final Itinerary itinerary;

  const UpdateItineraryInfoSuccess(this.itinerary);

  @override
  List<Object> get props => [itinerary];
}

class UpdateItineraryInfoFailure extends UpdateItineraryInfoState {
  final String message;

  const UpdateItineraryInfoFailure(this.message);

  @override
  List<Object> get props => [message];
}
