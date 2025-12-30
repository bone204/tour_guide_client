import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/anniversary_check_response.dart';

abstract class AnniversaryState extends Equatable {
  const AnniversaryState();

  @override
  List<Object> get props => [];
}

class AnniversaryInitial extends AnniversaryState {}

class AnniversaryLoading extends AnniversaryState {}

class AnniversarySuccess extends AnniversaryState {
  final AnniversaryCheckResponse response;

  const AnniversarySuccess(this.response);

  @override
  List<Object> get props => [response];
}

class AnniversaryFailure extends AnniversaryState {
  final String message;

  const AnniversaryFailure(this.message);

  @override
  List<Object> get props => [message];
}
