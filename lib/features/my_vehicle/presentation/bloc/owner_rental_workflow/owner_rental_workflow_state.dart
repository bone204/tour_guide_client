import 'package:equatable/equatable.dart';

enum OwnerRentalWorkflowStatus { initial, loading, success, failure }

enum OwnerRentalWorkflowAction {
  none,
  startDelivering,
  confirmDelivered,
  confirmReturn,
}

class OwnerRentalWorkflowState extends Equatable {
  final OwnerRentalWorkflowStatus status;
  final String? errorMessage;
  final String? successMessage;
  final OwnerRentalWorkflowAction action;

  const OwnerRentalWorkflowState({
    this.status = OwnerRentalWorkflowStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.action = OwnerRentalWorkflowAction.none,
  });

  OwnerRentalWorkflowState copyWith({
    OwnerRentalWorkflowStatus? status,
    String? errorMessage,
    String? successMessage,
    OwnerRentalWorkflowAction? action,
  }) {
    return OwnerRentalWorkflowState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      action: action ?? this.action,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, successMessage, action];
}
