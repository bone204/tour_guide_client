import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';

enum VehicleDetailStatus { initial, loading, success, error }

class VehicleDetailState extends Equatable {
  final VehicleDetailStatus status;
  final RentalVehicle? vehicle;
  final String? message;

  const VehicleDetailState({
    this.status = VehicleDetailStatus.initial,
    this.vehicle,
    this.message,
  });

  VehicleDetailState copyWith({
    VehicleDetailStatus? status,
    RentalVehicle? vehicle,
    String? message,
  }) {
    return VehicleDetailState(
      status: status ?? this.status,
      vehicle: vehicle ?? this.vehicle,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, vehicle, message];
}
