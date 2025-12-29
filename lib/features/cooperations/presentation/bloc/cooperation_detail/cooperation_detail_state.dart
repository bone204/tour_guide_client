import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/cooperations/data/models/cooperation.dart';

abstract class CooperationDetailState extends Equatable {
  const CooperationDetailState();

  @override
  List<Object?> get props => [];
}

class CooperationDetailInitial extends CooperationDetailState {}

class CooperationDetailLoading extends CooperationDetailState {}

class CooperationDetailLoaded extends CooperationDetailState {
  final Cooperation cooperation;

  const CooperationDetailLoaded(this.cooperation);

  @override
  List<Object?> get props => [cooperation];
}

class CooperationDetailError extends CooperationDetailState {
  final String message;

  const CooperationDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
