import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/services/bank/data/models/bank.dart';

abstract class GetBanksState extends Equatable {
  const GetBanksState();

  @override
  List<Object> get props => [];
}

class GetBanksInitial extends GetBanksState {}

class GetBanksLoading extends GetBanksState {}

class GetBanksLoaded extends GetBanksState {
  final List<Bank> banks;

  const GetBanksLoaded(this.banks);

  @override
  List<Object> get props => [banks];
}

class GetBanksError extends GetBanksState {
  final String message;

  const GetBanksError(this.message);

  @override
  List<Object> get props => [message];
}
