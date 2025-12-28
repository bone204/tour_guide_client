import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';

enum SuggestItineraryStatus { initial, loading, success, failure }

class SuggestItineraryState extends Equatable {
  final SuggestItineraryStatus status;
  final Itinerary? suggestedItinerary;
  final String? errorMessage;

  const SuggestItineraryState({
    this.status = SuggestItineraryStatus.initial,
    this.suggestedItinerary,
    this.errorMessage,
  });

  SuggestItineraryState copyWith({
    SuggestItineraryStatus? status,
    Itinerary? suggestedItinerary,
    String? errorMessage,
  }) {
    return SuggestItineraryState(
      status: status ?? this.status,
      suggestedItinerary: suggestedItinerary ?? this.suggestedItinerary,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, suggestedItinerary, errorMessage];
}
