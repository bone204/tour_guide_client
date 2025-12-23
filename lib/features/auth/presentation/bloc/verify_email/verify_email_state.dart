import 'package:equatable/equatable.dart';

abstract class VerifyEmailState extends Equatable {
  const VerifyEmailState();

  @override
  List<Object> get props => [];
}

class VerifyEmailInitial extends VerifyEmailState {}

class SendCodeLoading extends VerifyEmailState {}

class VerifyCodeLoading extends VerifyEmailState {}

class VerifyEmailValues extends VerifyEmailState {
  final String token;
  const VerifyEmailValues({required this.token});
}

class VerifyEmailSuccess extends VerifyEmailState {
  final String message;
  const VerifyEmailSuccess({required this.message});
}

class VerifyEmailFailure extends VerifyEmailState {
  final String message;

  const VerifyEmailFailure(this.message);

  @override
  List<Object> get props => [message];
}

class SendCodeSuccess extends VerifyEmailState {
  final String token;
  final String message;

  const SendCodeSuccess({required this.token, required this.message});

  @override
  List<Object> get props => [token, message];
}
