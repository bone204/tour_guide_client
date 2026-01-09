import 'dart:io';
import 'package:equatable/equatable.dart';

enum VerifyCitizenIdStatus { initial, loading, success, failure }

class VerifyCitizenIdState extends Equatable {
  final VerifyCitizenIdStatus status;
  final File? citizenFront;
  final File? selfie;
  final String? errorMessage;
  final String? successMessage;

  const VerifyCitizenIdState({
    this.status = VerifyCitizenIdStatus.initial,
    this.citizenFront,
    this.selfie,
    this.errorMessage,
    this.successMessage,
  });

  VerifyCitizenIdState copyWith({
    VerifyCitizenIdStatus? status,
    File? citizenFront,
    File? selfie,
    String? errorMessage,
    String? successMessage,
  }) {
    return VerifyCitizenIdState(
      status: status ?? this.status,
      citizenFront: citizenFront ?? this.citizenFront,
      selfie: selfie ?? this.selfie,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    citizenFront,
    selfie,
    errorMessage,
    successMessage,
  ];
}
