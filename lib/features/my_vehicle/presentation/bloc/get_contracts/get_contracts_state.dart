import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract.dart';

enum GetContractsStatus { initial, loading, loaded, error }

class GetContractsState extends Equatable {
  final GetContractsStatus status;
  final List<Contract> contracts;
  final String? message;

  const GetContractsState({
    this.status = GetContractsStatus.initial,
    this.contracts = const [],
    this.message,
  });

  GetContractsState copyWith({
    GetContractsStatus? status,
    List<Contract>? contracts,
    String? message,
  }) {
    return GetContractsState(
      status: status ?? this.status,
      contracts: contracts ?? this.contracts,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, contracts, message];
}
