import 'package:equatable/equatable.dart';

abstract class VerifyPhoneState extends Equatable {
  const VerifyPhoneState();

  @override
  List<Object> get props => [];
}

class VerifyPhoneInitial extends VerifyPhoneState {}

class VerifyPhoneLoading extends VerifyPhoneState {}

class VerifyPhoneCodeSent extends VerifyPhoneState {
  final String sessionInfo;
  final String phone;

  const VerifyPhoneCodeSent({required this.sessionInfo, required this.phone});

  @override
  List<Object> get props => [sessionInfo, phone];
}

class VerifyPhoneVerifying extends VerifyPhoneState {}

class VerifyPhoneSuccess extends VerifyPhoneState {}

class VerifyPhoneFailure extends VerifyPhoneState {
  final String message;

  const VerifyPhoneFailure(this.message);

  @override
  List<Object> get props => [message];
}
