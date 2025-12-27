import 'package:equatable/equatable.dart';

abstract class UpdateHobbiesState extends Equatable {
  const UpdateHobbiesState();

  @override
  List<Object> get props => [];
}

class UpdateHobbiesInitial extends UpdateHobbiesState {}

class UpdateHobbiesLoading extends UpdateHobbiesState {}

class UpdateHobbiesSuccess extends UpdateHobbiesState {}

class UpdateHobbiesFailure extends UpdateHobbiesState {
  final String errorMessage;

  const UpdateHobbiesFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
