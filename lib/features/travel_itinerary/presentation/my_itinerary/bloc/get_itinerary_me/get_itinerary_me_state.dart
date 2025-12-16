part of 'get_itinerary_me_cubit.dart';

abstract class GetItineraryMeState extends Equatable {
  const GetItineraryMeState();

  @override
  List<Object> get props => [];
}

class GetItineraryMeInitial extends GetItineraryMeState {}

class GetItineraryMeLoading extends GetItineraryMeState {}

class GetItineraryMeSuccess extends GetItineraryMeState {
  final List<Itinerary> itineraries;

  const GetItineraryMeSuccess(this.itineraries);

  @override
  List<Object> get props => [itineraries];
}

class GetItineraryMeFailure extends GetItineraryMeState {
  final String message;

  const GetItineraryMeFailure(this.message);

  @override
  List<Object> get props => [message];
}
