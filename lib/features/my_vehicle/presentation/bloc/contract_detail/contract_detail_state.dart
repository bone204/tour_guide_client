import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract.dart';

abstract class ContractDetailState extends Equatable {
  const ContractDetailState();

  @override
  List<Object?> get props => [];
}

class ContractDetailInitial extends ContractDetailState {
  const ContractDetailInitial();
}

class ContractDetailLoading extends ContractDetailState {
  const ContractDetailLoading();
}

class ContractDetailSuccess extends ContractDetailState {
  final Contract contract;

  const ContractDetailSuccess(this.contract);

  @override
  List<Object?> get props => [contract];
}

class ContractDetailFailure extends ContractDetailState {
  final String message;

  const ContractDetailFailure(this.message);

  @override
  List<Object?> get props => [message];
}

