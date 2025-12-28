part of 'get_eateries_cubit.dart';

abstract class GetEateriesState extends Equatable {
  const GetEateriesState();

  @override
  List<Object> get props => [];
}

class GetEateriesInitial extends GetEateriesState {}

class GetEateriesLoading extends GetEateriesState {}

class GetEateriesSuccess extends GetEateriesState {
  final List<Eatery> eateries;

  const GetEateriesSuccess(this.eateries);

  @override
  List<Object> get props => [eateries];
}

class GetEateriesFailure extends GetEateriesState {
  final String message;

  const GetEateriesFailure(this.message);

  @override
  List<Object> get props => [message];
}
