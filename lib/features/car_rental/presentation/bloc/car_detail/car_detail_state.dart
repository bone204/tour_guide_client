import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';

enum CarDetailStatus { initial, loading, success, failure }

class CarDetailState extends Equatable {
  final CarDetailStatus status;
  final RentalVehicle? vehicle;
  final String? errorMessage;

  const CarDetailState({
    this.status = CarDetailStatus.initial,
    this.vehicle,
    this.errorMessage,
  });

  CarDetailState copyWith({
    CarDetailStatus? status,
    RentalVehicle? vehicle,
    String? errorMessage,
  }) {
    return CarDetailState(
      status: status ?? this.status,
      vehicle: vehicle ?? this.vehicle,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, vehicle, errorMessage];
}
