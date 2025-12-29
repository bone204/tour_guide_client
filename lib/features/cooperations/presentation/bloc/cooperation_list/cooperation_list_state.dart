import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/cooperations/data/models/cooperation.dart';

abstract class CooperationListState extends Equatable {
  const CooperationListState();

  @override
  List<Object?> get props => [];
}

class CooperationListInitial extends CooperationListState {}

class CooperationListLoading extends CooperationListState {}

class CooperationListLoaded extends CooperationListState {
  final List<Cooperation> hotels;
  final List<Cooperation> restaurants;
  final bool isHotelLoading;
  final bool isRestaurantLoading;

  const CooperationListLoaded({
    this.hotels = const [],
    this.restaurants = const [],
    this.isHotelLoading = false,
    this.isRestaurantLoading = false,
  });

  CooperationListLoaded copyWith({
    List<Cooperation>? hotels,
    List<Cooperation>? restaurants,
    bool? isHotelLoading,
    bool? isRestaurantLoading,
  }) {
    return CooperationListLoaded(
      hotels: hotels ?? this.hotels,
      restaurants: restaurants ?? this.restaurants,
      isHotelLoading: isHotelLoading ?? this.isHotelLoading,
      isRestaurantLoading: isRestaurantLoading ?? this.isRestaurantLoading,
    );
  }

  @override
  List<Object?> get props => [
    hotels,
    restaurants,
    isHotelLoading,
    isRestaurantLoading,
  ];
}

class CooperationListError extends CooperationListState {
  final String message;

  const CooperationListError(this.message);

  @override
  List<Object?> get props => [message];
}
