part of 'get_eatery_detail_cubit.dart';

abstract class GetEateryDetailState extends Equatable {
  const GetEateryDetailState();

  @override
  List<Object> get props => [];
}

class GetEateryDetailInitial extends GetEateryDetailState {}

class GetEateryDetailLoading extends GetEateryDetailState {}

class GetEateryDetailSuccess extends GetEateryDetailState {
  final Eatery eatery;

  const GetEateryDetailSuccess(this.eatery);

  @override
  List<Object> get props => [eatery];
}

class GetEateryDetailFailure extends GetEateryDetailState {
  final String message;

  const GetEateryDetailFailure(this.message);

  @override
  List<Object> get props => [message];
}
