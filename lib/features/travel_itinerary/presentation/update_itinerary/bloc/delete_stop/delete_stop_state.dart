import 'package:equatable/equatable.dart';

abstract class DeleteStopState extends Equatable {
  const DeleteStopState();

  @override
  List<Object> get props => [];
}

class DeleteStopInitial extends DeleteStopState {}

class DeleteStopLoading extends DeleteStopState {}

class DeleteStopSuccess extends DeleteStopState {}

class DeleteStopFailure extends DeleteStopState {
  final String message;

  const DeleteStopFailure(this.message);

  @override
  List<Object> get props => [message];
}
