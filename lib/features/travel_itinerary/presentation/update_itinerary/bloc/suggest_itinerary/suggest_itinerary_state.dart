import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';

enum SuggestItineraryStatus { initial, loading, success, failure }

enum ClaimStatus { initial, loading, success, failure }

class SuggestItineraryState extends Equatable {
  final SuggestItineraryStatus status;
  final Itinerary? suggestedItinerary;
  final String? errorMessage;

  final ClaimStatus claimStatus;
  final Itinerary? claimedItinerary;

  const SuggestItineraryState({
    this.status = SuggestItineraryStatus.initial,
    this.claimStatus = ClaimStatus.initial,
    this.suggestedItinerary,
    this.claimedItinerary,
    this.errorMessage,
  });

  SuggestItineraryState copyWith({
    SuggestItineraryStatus? status,
    ClaimStatus? claimStatus,
    Itinerary? suggestedItinerary,
    Itinerary? claimedItinerary,
    String? errorMessage,
  }) {
    return SuggestItineraryState(
      status: status ?? this.status,
      claimStatus: claimStatus ?? this.claimStatus,
      suggestedItinerary: suggestedItinerary ?? this.suggestedItinerary,
      claimedItinerary: claimedItinerary ?? this.claimedItinerary,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    claimStatus,
    suggestedItinerary,
    claimedItinerary,
    errorMessage,
  ];
}
