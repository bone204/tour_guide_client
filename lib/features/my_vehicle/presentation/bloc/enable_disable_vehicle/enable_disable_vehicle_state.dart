import 'package:equatable/equatable.dart';

enum EnableDisableVehicleStatus { initial, loading, success, error }

class EnableDisableVehicleState extends Equatable {
  final EnableDisableVehicleStatus status;
  final String? message;

  const EnableDisableVehicleState({
    this.status = EnableDisableVehicleStatus.initial,
    this.message,
  });

  EnableDisableVehicleState copyWith({
    EnableDisableVehicleStatus? status,
    String? message,
  }) {
    return EnableDisableVehicleState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, message];
}
