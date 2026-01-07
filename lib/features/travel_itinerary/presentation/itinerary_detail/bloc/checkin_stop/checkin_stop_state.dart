import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/checkin_stop_response.dart';

abstract class CheckInStopState extends Equatable {
  const CheckInStopState();

  @override
  List<Object?> get props => [];
}

class CheckInStopInitial extends CheckInStopState {}

class CheckInStopLoading extends CheckInStopState {}

class CheckInStopSuccess extends CheckInStopState {
  final CheckInStopResponse response;

  const CheckInStopSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class CheckInStopFailure extends CheckInStopState {
  final String message;

  const CheckInStopFailure(this.message);

  @override
  List<Object?> get props => [message];
}
