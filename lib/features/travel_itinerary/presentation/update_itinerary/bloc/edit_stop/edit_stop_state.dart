import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';

abstract class EditStopState extends Equatable {
  const EditStopState();

  @override
  List<Object> get props => [];
}

class EditStopInitial extends EditStopState {}

class EditStopLoading extends EditStopState {}

class EditStopSuccess extends EditStopState {
  final Stop stop;
  final String message;

  const EditStopSuccess({required this.stop, required this.message});

  @override
  List<Object> get props => [stop, message];
}

class EditStopFailure extends EditStopState {
  final String message;

  const EditStopFailure({required this.message});

  @override
  List<Object> get props => [message];
}
