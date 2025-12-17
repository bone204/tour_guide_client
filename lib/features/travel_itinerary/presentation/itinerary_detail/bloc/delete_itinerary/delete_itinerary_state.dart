part of 'delete_itinerary_cubit.dart';

abstract class DeleteItineraryState extends Equatable {
  const DeleteItineraryState();

  @override
  List<Object> get props => [];
}

class DeleteItineraryInitial extends DeleteItineraryState {}

class DeleteItineraryLoading extends DeleteItineraryState {}

class DeleteItinerarySuccess extends DeleteItineraryState {}

class DeleteItineraryFailure extends DeleteItineraryState {
  final String message;

  const DeleteItineraryFailure(this.message);

  @override
  List<Object> get props => [message];
}
