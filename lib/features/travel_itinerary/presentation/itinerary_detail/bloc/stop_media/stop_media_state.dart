import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';

abstract class StopMediaState extends Equatable {
  const StopMediaState();

  @override
  List<Object> get props => [];
}

class StopMediaInitial extends StopMediaState {}

class StopMediaLoading extends StopMediaState {}

class StopMediaLoaded extends StopMediaState {
  final Stop stop;
  const StopMediaLoaded(this.stop);
  @override
  List<Object> get props => [stop];
}

class StopMediaUploaded extends StopMediaState {
  final Stop stop;
  const StopMediaUploaded(this.stop);
  @override
  List<Object> get props => [stop];
}

class StopMediaFailure extends StopMediaState {
  final String message;

  const StopMediaFailure(this.message);

  @override
  List<Object> get props => [message];
}
