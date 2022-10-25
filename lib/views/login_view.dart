import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:notes/services/auth/auth_exceptions.dart';

import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';

import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'User not found');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('login'),
        ),
        body: Container(
          padding: const EdgeInsets.all(17),
          child: Column(
            children: [
              Image.asset(
                'assets/icon/image.png',
                height: 180,
                scale: 2.0,
                opacity: const AlwaysStoppedAnimation(0.75),
                alignment: Alignment.topCenter,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 27, 0, 0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xff332900),
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(hintText: 'Email'),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xff332900),
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(hintText: 'Password'),
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(80, 15, 10, 15),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0xFFFECD00),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        context.read<AuthBloc>().add(
                              AuthEventLogIn(
                                email,
                                password,
                              ),
                            );
                      },
                      child: const Text(
                        '   Log In   ',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(30, 15, 70, 15),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0xFFFECD00),
                    ),
                    child: TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              const AuthEventShouldRegister(),
                            );
                      },
                      child: const Text(
                        '  Sign Up  ',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xFFFECD00),
                ),
                child: TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventForgotPassword(),
                          );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.black),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
