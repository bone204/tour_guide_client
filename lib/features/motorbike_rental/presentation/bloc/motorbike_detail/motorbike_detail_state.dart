import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';

enum MotorbikeDetailStatus { initial, loading, success, failure }

class MotorbikeDetailState extends Equatable {
  final MotorbikeDetailStatus status;
  final RentalVehicle? vehicle;
  final String? errorMessage;

  const MotorbikeDetailState({
    this.status = MotorbikeDetailStatus.initial,
    this.vehicle,
    this.errorMessage,
  });

  MotorbikeDetailState copyWith({
    MotorbikeDetailStatus? status,
    RentalVehicle? vehicle,
    String? errorMessage,
  }) {
    return MotorbikeDetailState(
      status: status ?? this.status,
      vehicle: vehicle ?? this.vehicle,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, vehicle, errorMessage];
}
