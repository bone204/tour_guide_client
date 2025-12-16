part of 'get_itinerary_detail_cubit.dart';

abstract class GetItineraryDetailState extends Equatable {
  const GetItineraryDetailState();

  @override
  List<Object> get props => [];
}

class GetItineraryDetailInitial extends GetItineraryDetailState {}

class GetItineraryDetailLoading extends GetItineraryDetailState {}

class GetItineraryDetailSuccess extends GetItineraryDetailState {
  final Itinerary itinerary;

  const GetItineraryDetailSuccess(this.itinerary);

  @override
  List<Object> get props => [itinerary];
}

class GetItineraryDetailFailure extends GetItineraryDetailState {
  final String message;

  const GetItineraryDetailFailure(this.message);

  @override
  List<Object> get props => [message];
}
