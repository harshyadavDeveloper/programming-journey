import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blocs/apps/bloc/login/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc _loginBloc;
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc();
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _loginBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<LoginBloc, LoginBlocState>(
                buildWhen: (prev, curr) => prev.email != curr.email,
                builder: (context, state) {
                  return TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    focusNode: emailFocusNode,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      context.read<LoginBloc>().add(EmailChanged(email: val));
                    },
                    onFieldSubmitted: (val) {},
                  );
                },
              ),
              const SizedBox(height: 20),
              BlocBuilder<LoginBloc, LoginBlocState>(
                buildWhen: (prev, curr) => prev.password != curr.password,
                builder: (context, state) {
                  return TextFormField(
                    keyboardType: TextInputType.text,
                    focusNode: passwordFocusNode,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      context.read<LoginBloc>().add(
                        PasswordChanged(password: val),
                      );
                    },
                    onFieldSubmitted: (val) {},
                  );
                },
              ),
              const SizedBox(height: 50),
              BlocListener<LoginBloc, LoginBlocState>(
                listenWhen: (prev, curr) =>
                    prev.loginStatus != curr.loginStatus,
                listener: (context, state) {
                  if (state.loginStatus == LoginState.error) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(content: Text(state.message.toString())),
                      );
                  }

                  if (state.loginStatus == LoginState.loading) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text('Submitting')));
                  }

                  if (state.loginStatus == LoginState.success) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text('Login Successs')));
                  }
                },
                child: BlocBuilder<LoginBloc, LoginBlocState>(
                  buildWhen: (prev, curr) => false,
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        context.read<LoginBloc>().add(SubmitForm());
                      },
                      child: const Text('Login'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
