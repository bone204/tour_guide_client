import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle.dart';

abstract class GetVehiclesState {}

class GetVehiclesInitial extends GetVehiclesState {}

class GetVehiclesLoading extends GetVehiclesState {}

class GetVehiclesSuccess extends GetVehiclesState {
  final List<Vehicle> vehicles;

  GetVehiclesSuccess({required this.vehicles});
}

class GetVehiclesEmpty extends GetVehiclesState {}

class GetVehiclesFailure extends GetVehiclesState {
  final String errorMessage;

  GetVehiclesFailure({required this.errorMessage});
}

