part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class ForgotPasswordSent extends AuthState {
  const ForgotPasswordSent();
}

class SignedIn extends AuthState {
  const SignedIn(this.user);
  //return localuser
  final LocalUser user;

  @override
  List<Object> get props => [user];
}

class SignedUp extends AuthState {
  const SignedUp();
  //return void/nothing
}

class UserUpdated extends AuthState {
  const UserUpdated();
}

class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}
