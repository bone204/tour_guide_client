import 'package:equatable/equatable.dart';

abstract class UpdateContactInfoState extends Equatable {
  const UpdateContactInfoState();

  @override
  List<Object?> get props => [];
}

class UpdateContactInfoInitial extends UpdateContactInfoState {}

class UpdateContactInfoLoading extends UpdateContactInfoState {}

class UpdateContactInfoSuccess extends UpdateContactInfoState {}

class UpdateContactInfoFailure extends UpdateContactInfoState {
  final String errorMessage;

  const UpdateContactInfoFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
