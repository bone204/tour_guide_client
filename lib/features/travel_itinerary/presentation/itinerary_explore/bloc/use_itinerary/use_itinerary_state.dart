import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/success/success_response.dart';

abstract class UseItineraryState extends Equatable {
  const UseItineraryState();

  @override
  List<Object> get props => [];
}

class UseItineraryInitial extends UseItineraryState {}

class UseItineraryLoading extends UseItineraryState {}

class UseItinerarySuccess extends UseItineraryState {
  final SuccessResponse response;

  const UseItinerarySuccess(this.response);

  @override
  List<Object> get props => [response];
}

class UseItineraryFailure extends UseItineraryState {
  final String message;

  const UseItineraryFailure(this.message);

  @override
  List<Object> get props => [message];
}
