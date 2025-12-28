import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';

enum SearchCarStatus { initial, loading, success, failure }

class SearchCarState extends Equatable {
  final SearchCarStatus status;
  final List<RentalVehicle> cars;
  final String? errorMessage;

  const SearchCarState({
    this.status = SearchCarStatus.initial,
    this.cars = const [],
    this.errorMessage,
  });

  SearchCarState copyWith({
    SearchCarStatus? status,
    List<RentalVehicle>? cars,
    String? errorMessage,
  }) {
    return SearchCarState(
      status: status ?? this.status,
      cars: cars ?? this.cars,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, cars, errorMessage];
}
