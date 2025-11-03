abstract class AddVehicleState {}

class AddVehicleInitial extends AddVehicleState {}

class AddVehicleLoading extends AddVehicleState {}

class AddVehicleSuccess extends AddVehicleState {
  final String message;

  AddVehicleSuccess({required this.message});
}

class AddVehicleFailure extends AddVehicleState {
  final String errorMessage;

  AddVehicleFailure({required this.errorMessage});
}

