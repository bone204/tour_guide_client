import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/cooperations/data/models/cooperation.dart';

abstract class GetFavoriteCooperationsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetFavoriteCooperationsInitial extends GetFavoriteCooperationsState {}

class GetFavoriteCooperationsLoading extends GetFavoriteCooperationsState {}

class GetFavoriteCooperationsLoaded extends GetFavoriteCooperationsState {
  final List<Cooperation> cooperations;

  GetFavoriteCooperationsLoaded({required this.cooperations});

  @override
  List<Object?> get props => [cooperations];
}

class GetFavoriteCooperationsError extends GetFavoriteCooperationsState {
  final String message;

  GetFavoriteCooperationsError(this.message);

  @override
  List<Object?> get props => [message];
}
