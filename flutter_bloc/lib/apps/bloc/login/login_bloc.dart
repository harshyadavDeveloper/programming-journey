import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
part 'login_bloc_event.dart';
part 'login_bloc_state.dart';

class LoginBloc extends Bloc<LoginBlocEvent, LoginBlocState> {
  LoginBloc() : super(LoginBlocState()) {
    on<EmailChanged>(_emailChangeHandler);
    on<PasswordChanged>(_passwordChangeHandler);
    on<SubmitForm>(_handleLoginApi);
  }

  void _emailChangeHandler(EmailChanged event, Emitter<LoginBlocState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _passwordChangeHandler(
    PasswordChanged event,
    Emitter<LoginBlocState> emit,
  ) {
    emit(state.copyWith(password: event.password));
  }

  void _handleLoginApi(SubmitForm event, Emitter<LoginBlocState> emit) async {
    emit(state.copyWith(loginStatus: LoginState.loading));
    Map<String, dynamic> body = {
      'email': state.email,
      'password': state.password,
    };
    try {
      final response = await http.post(
        Uri.parse('https://reqres.in/api/login'),
        body: body,
      );
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        emit(
          state.copyWith(
            loginStatus: LoginState.success,
            message: 'Login Success',
          ),
        );
      } else {
        emit(
          state.copyWith(
            loginStatus: LoginState.error,
            message: jsonData['error'],
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(loginStatus: LoginState.error, message: e.toString()),
      );
    }
  }
}
