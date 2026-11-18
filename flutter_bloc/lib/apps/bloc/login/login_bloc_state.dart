part of 'login_bloc.dart';

enum LoginState { initial, loading, success, error }

class LoginBlocState extends Equatable {
  final String email;
  final String password;
  final String message;
  final LoginState loginStatus;

  const LoginBlocState({
    this.email = '',
    this.password = '',
    this.message = '',
    this.loginStatus = LoginState.initial,
  });

  LoginBlocState copyWith({
    String? email,
    String? password,
    String? message,
    LoginState? loginStatus,
  }) {
    return LoginBlocState(
      email: email ?? this.email,
      password: password ?? this.password,
      message: message ?? this.message,
      loginStatus: loginStatus ?? this.loginStatus,
    );
  }

  @override
  List<Object?> get props => [email, password, message, loginStatus];
}
