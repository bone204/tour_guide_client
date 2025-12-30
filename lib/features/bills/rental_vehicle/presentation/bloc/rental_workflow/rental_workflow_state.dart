import 'package:equatable/equatable.dart';

enum RentalWorkflowStatus { initial, loading, success, failure }

enum RentalWorkflowAction { none, pickup, returnRequest }

class RentalWorkflowState extends Equatable {
  final RentalWorkflowStatus status;
  final String? errorMessage;
  final String? successMessage;
  final RentalWorkflowAction action;

  const RentalWorkflowState({
    this.status = RentalWorkflowStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.action = RentalWorkflowAction.none,
  });

  RentalWorkflowState copyWith({
    RentalWorkflowStatus? status,
    String? errorMessage,
    String? successMessage,
    RentalWorkflowAction? action,
  }) {
    return RentalWorkflowState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      action: action ?? this.action,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, successMessage, action];
}
