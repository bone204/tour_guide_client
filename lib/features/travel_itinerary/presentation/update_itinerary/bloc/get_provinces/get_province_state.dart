import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/province.dart';

abstract class GetProvinceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetProvinceInitial extends GetProvinceState {}

class GetProvinceLoading extends GetProvinceState {}

class GetProvinceLoaded extends GetProvinceState {
  final List<Province> provinces;
  final String? search;
  GetProvinceLoaded({required this.provinces, this.search});

  @override
  List<Object?> get props => [provinces, search];
}

class GetProvinceError extends GetProvinceState {
  final String message;
  GetProvinceError(this.message);
  @override
  List<Object?> get props => [message];
}
