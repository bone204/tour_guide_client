import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';

enum GetMyVehiclesStatus { initial, loading, loaded, error }

class GetMyVehiclesState extends Equatable {
  final GetMyVehiclesStatus status;
  final List<RentalVehicle> vehicles;
  final String? message;

  const GetMyVehiclesState({
    this.status = GetMyVehiclesStatus.initial,
    this.vehicles = const [],
    this.message,
  });

  GetMyVehiclesState copyWith({
    GetMyVehiclesStatus? status,
    List<RentalVehicle>? vehicles,
    String? message,
  }) {
    return GetMyVehiclesState(
      status: status ?? this.status,
      vehicles: vehicles ?? this.vehicles,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, vehicles, message];
}
