import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';

abstract class PublicizeItineraryState extends Equatable {
  const PublicizeItineraryState();

  @override
  List<Object?> get props => [];
}

class PublicizeItineraryInitial extends PublicizeItineraryState {}

class PublicizeItineraryLoading extends PublicizeItineraryState {}

class PublicizeItinerarySuccess extends PublicizeItineraryState {
  final Itinerary itinerary;

  const PublicizeItinerarySuccess(this.itinerary);

  @override
  List<Object?> get props => [itinerary];
}

class PublicizeItineraryFailure extends PublicizeItineraryState {
  final String message;

  const PublicizeItineraryFailure(this.message);

  @override
  List<Object?> get props => [message];
}
