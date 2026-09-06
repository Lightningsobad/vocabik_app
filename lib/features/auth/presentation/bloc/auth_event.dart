part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LogoutRequested extends AuthEvent {}

class GetMeRequested extends AuthEvent {
  const GetMeRequested();
}

class UserAuthenticated extends AuthEvent {
  final User user;

  const UserAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class UserProfileUpdated extends AuthEvent {
  final User user;

  const UserProfileUpdated(this.user);

  @override
  List<Object> get props => [user];
}

