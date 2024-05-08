part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class VerifyAuthEvent extends AuthEvent {}

class AnonymousAuthEvent extends AuthEvent {}

class GoogleAuthEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent({required this.email, required this.password});
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String country;
  final String dob;
  final String profileImageUrl;

  RegisterEvent(
      {required this.email,
      required this.password,
      required this.firstName,
      required this.lastName,
      required this.country,
      required this.dob,
      required this.profileImageUrl});
}
