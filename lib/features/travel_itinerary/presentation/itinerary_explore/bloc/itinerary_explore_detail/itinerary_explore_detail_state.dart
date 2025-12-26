import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';

abstract class ItineraryExploreDetailState extends Equatable {
  const ItineraryExploreDetailState();
}

class ItineraryExploreDetailInitial extends ItineraryExploreDetailState {
  @override
  List<Object> get props => [];
}

class ItineraryExploreDetailLoading extends ItineraryExploreDetailState {
  @override
  List<Object> get props => [];
}

class ItineraryExploreDetailSuccess extends ItineraryExploreDetailState {
  final Itinerary itinerary;

  const ItineraryExploreDetailSuccess(this.itinerary);

  @override
  List<Object> get props => [itinerary];
}

class ItineraryExploreDetailFailure extends ItineraryExploreDetailState {
  final String message;

  const ItineraryExploreDetailFailure(this.message);

  @override
  List<Object> get props => [message];
}
