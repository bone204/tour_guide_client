part of 'add_stop_cubit.dart';

abstract class AddStopState extends Equatable {
  const AddStopState();

  @override
  List<Object> get props => [];
}

class AddStopInitial extends AddStopState {}

class AddStopLoading extends AddStopState {}

class AddStopSuccess extends AddStopState {
  final Stop stop;

  const AddStopSuccess(this.stop);

  @override
  List<Object> get props => [stop];
}

class AddStopFailure extends AddStopState {
  final String message;

  const AddStopFailure(this.message);

  @override
  List<Object> get props => [message];
}
