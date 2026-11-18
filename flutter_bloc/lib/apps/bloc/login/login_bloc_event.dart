part of 'login_bloc.dart';

abstract class LoginBlocEvent extends Equatable {
  const LoginBlocEvent();

  @override
  List<Object?> get props => [];
}

class EmailChanged extends LoginBlocEvent {
  final String email;

  const EmailChanged({required this.email});

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends LoginBlocEvent {
  final String password;

  const PasswordChanged({required this.password});

  @override
  List<Object?> get props => [password];
}

class SubmitForm extends LoginBlocEvent {}
