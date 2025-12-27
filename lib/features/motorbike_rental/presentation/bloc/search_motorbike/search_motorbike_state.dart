import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';

enum SearchMotorbikeStatus { initial, loading, success, failure }

class SearchMotorbikeState extends Equatable {
  final SearchMotorbikeStatus status;
  final List<RentalVehicle> motorbikes;
  final String? errorMessage;

  const SearchMotorbikeState({
    this.status = SearchMotorbikeStatus.initial,
    this.motorbikes = const [],
    this.errorMessage,
  });

  SearchMotorbikeState copyWith({
    SearchMotorbikeStatus? status,
    List<RentalVehicle>? motorbikes,
    String? errorMessage,
  }) {
    return SearchMotorbikeState(
      status: status ?? this.status,
      motorbikes: motorbikes ?? this.motorbikes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, motorbikes, errorMessage];
}
