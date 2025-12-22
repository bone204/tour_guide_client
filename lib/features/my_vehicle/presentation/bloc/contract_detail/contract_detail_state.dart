import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract.dart';

enum ContractDetailStatus { initial, loading, loaded, error }

class ContractDetailState extends Equatable {
  final ContractDetailStatus status;
  final Contract? contract;
  final String? message;

  const ContractDetailState({
    this.status = ContractDetailStatus.initial,
    this.contract,
    this.message,
  });

  ContractDetailState copyWith({
    ContractDetailStatus? status,
    Contract? contract,
    String? message,
  }) {
    return ContractDetailState(
      status: status ?? this.status,
      contract: contract ?? this.contract,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, contract, message];
}
