import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/utilities/show_error_dialog.dart';
import 'package:notes/constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(hintText: 'Email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(hintText: 'Password'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );

                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                showErrorDialog(context, 'weak password');
              } on EmailAlreadyInUseAuthException {
                showErrorDialog(context, 'email already register');
              } on InvalidEmailAuthException {
                showErrorDialog(context, 'This is a invalid email');
              } on GenericAuthException {
                showErrorDialog(
                  context,
                  'Failed to register',
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Already registered? Click here to Login'),
          )
        ],
      ),
    );
  }
}
