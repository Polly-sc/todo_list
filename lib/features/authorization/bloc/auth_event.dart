part of 'auth_bloc.dart';

class AuthEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class SignInRequested extends AuthEvent{
  final String email;
  final String password;

  SignInRequested(this.email, this.password);
}

class SignUpRequested extends AuthEvent{
  final String email;
  final String password;

  SignUpRequested(this.email, this.password);
}

class GoogleSignInRequested extends AuthEvent{}

class SignOutRequested extends AuthEvent{}