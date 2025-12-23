import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/features/profile/data/models/user.dart';

abstract class GetMyProfileState extends Equatable {
  const GetMyProfileState();

  @override
  List<Object?> get props => [];
}

class GetMyProfileInitial extends GetMyProfileState {}

class GetMyProfileLoading extends GetMyProfileState {}

class GetMyProfileSuccess extends GetMyProfileState {
  final User user;

  const GetMyProfileSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class GetMyProfileFailure extends GetMyProfileState {
  final String message;

  const GetMyProfileFailure(this.message);

  @override
  List<Object?> get props => [message];
}
