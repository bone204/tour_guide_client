import 'package:equatable/equatable.dart';

enum RentalWorkflowStatus { initial, loading, success, failure }

class RentalWorkflowState extends Equatable {
  final RentalWorkflowStatus status;
  final String? errorMessage;
  final String? successMessage;

  const RentalWorkflowState({
    this.status = RentalWorkflowStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  RentalWorkflowState copyWith({
    RentalWorkflowStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return RentalWorkflowState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, successMessage];
}
