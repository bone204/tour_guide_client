import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/my_vehicle_v1/data/models/vehicle.dart';

abstract class VehicleDetailState extends Equatable {
  const VehicleDetailState();

  @override
  List<Object?> get props => [];
}

class VehicleDetailInitial extends VehicleDetailState {
  const VehicleDetailInitial();
}

class VehicleDetailLoading extends VehicleDetailState {
  const VehicleDetailLoading();
}

class VehicleDetailSuccess extends VehicleDetailState {
  final Vehicle vehicle;

  const VehicleDetailSuccess(this.vehicle);

  @override
  List<Object?> get props => [vehicle];
}

class VehicleDetailFailure extends VehicleDetailState {
  final String message;

  const VehicleDetailFailure(this.message);

  @override
  List<Object?> get props => [message];
}

