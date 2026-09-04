import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterDisplayNameChanged extends RegisterEvent {
  final String displayName;
  const RegisterDisplayNameChanged(this.displayName);

  @override
  List<Object> get props => [displayName];
}

class RegisterEmailChanged extends RegisterEvent {
  final String email;
  const RegisterEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;
  const RegisterPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted();
}

class RegisterWithGoogleSubmitted extends RegisterEvent {
  const RegisterWithGoogleSubmitted();
}

