import 'package:equatable/equatable.dart';

enum OwnerRentalWorkflowStatus { initial, loading, success, failure }

class OwnerRentalWorkflowState extends Equatable {
  final OwnerRentalWorkflowStatus status;
  final String? errorMessage;
  final String? successMessage;

  const OwnerRentalWorkflowState({
    this.status = OwnerRentalWorkflowStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  OwnerRentalWorkflowState copyWith({
    OwnerRentalWorkflowStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return OwnerRentalWorkflowState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, successMessage];
}
