import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';

abstract class GetDestinationByIdState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetDestinationByIdInitial extends GetDestinationByIdState {}

class GetDestinationByIdLoading extends GetDestinationByIdState {}

class GetDestinationByIdLoaded extends GetDestinationByIdState {
  final Destination destination;

  GetDestinationByIdLoaded(this.destination);

  @override
  List<Object?> get props => [destination];
}

class GetDestinationByIdError extends GetDestinationByIdState {
  final String message;

  GetDestinationByIdError(this.message);

  @override
  List<Object?> get props => [message];
}
