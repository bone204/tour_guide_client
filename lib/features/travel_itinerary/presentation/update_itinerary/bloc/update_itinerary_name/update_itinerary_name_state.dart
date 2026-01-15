part of 'update_itinerary_name_cubit.dart';

abstract class UpdateItineraryNameState extends Equatable {
  const UpdateItineraryNameState();

  @override
  List<Object> get props => [];
}

class UpdateItineraryNameInitial extends UpdateItineraryNameState {}

class UpdateItineraryNameLoading extends UpdateItineraryNameState {}

class UpdateItineraryNameSuccess extends UpdateItineraryNameState {
  final Itinerary itinerary;

  const UpdateItineraryNameSuccess(this.itinerary);

  @override
  List<Object> get props => [itinerary];
}

class UpdateItineraryNameFailure extends UpdateItineraryNameState {
  final String message;

  const UpdateItineraryNameFailure(this.message);

  @override
  List<Object> get props => [message];
}
