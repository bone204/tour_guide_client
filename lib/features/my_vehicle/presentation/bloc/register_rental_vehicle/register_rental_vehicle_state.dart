abstract class RegisterRentalVehicleState {}

class RegisterRentalVehicleInitial extends RegisterRentalVehicleState {}

class RegisterRentalVehicleLoading extends RegisterRentalVehicleState {}

class RegisterRentalVehicleSuccess extends RegisterRentalVehicleState {
  final String message;

  RegisterRentalVehicleSuccess({required this.message});
}

class RegisterRentalVehicleFailure extends RegisterRentalVehicleState {
  final String errorMessage;

  RegisterRentalVehicleFailure({required this.errorMessage});
}

