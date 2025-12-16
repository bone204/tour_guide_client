part of 'get_stop_detail_cubit.dart';

abstract class GetStopDetailState extends Equatable {
  const GetStopDetailState();

  @override
  List<Object> get props => [];
}

class GetStopDetailInitial extends GetStopDetailState {}

class GetStopDetailLoading extends GetStopDetailState {}

class GetStopDetailSuccess extends GetStopDetailState {
  final Stop stop;

  const GetStopDetailSuccess({required this.stop});

  @override
  List<Object> get props => [stop];
}

class GetStopDetailFailure extends GetStopDetailState {
  final String message;

  const GetStopDetailFailure({required this.message});

  @override
  List<Object> get props => [message];
}
