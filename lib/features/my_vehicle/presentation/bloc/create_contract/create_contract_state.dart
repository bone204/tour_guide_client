abstract class CreateContractState {}

class CreateContractInitial extends CreateContractState {}

class CreateContractLoading extends CreateContractState {}

class CreateContractSuccess extends CreateContractState {
  final String message;

  CreateContractSuccess({required this.message});
}

class CreateContractFailure extends CreateContractState {
  final String errorMessage;

  CreateContractFailure({required this.errorMessage});
}
