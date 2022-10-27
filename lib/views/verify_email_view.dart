import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/utilities/dialogs/error_dialog.dart';
import 'package:notes/utilities/dialogs/verify_email_sent_dialog.dart';

import '../services/auth/bloc/auth_state.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateNeedsVerification) {
          if (state.exception is VerificationEmailNotSentTooManyRequests) {
            await showErrorDialog(
                context, 'Too many request check your spam section ');
          }
          if (state.exception is UserNotLoggedInAuthException) {
            await showErrorDialog(context, 'you are not logged in ');
          } else {
            await showVerifictionEmailSentDialog(context);
          }
        }
        // TODO: implement listener
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Verify email'),
        ),
        body: Column(
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: const Text('We have sent you  email address')),
            const Text(
                'If you havent recived it yet please click on the button below'),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(110, 20, 110, 10),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xFFFECD00),
              ),
              child: TextButton(
                onPressed: () {
                  context
                      .read<AuthBloc>()
                      .add(const AuthEventSendEmailVerification());
                },
                child: const Text(
                  'Send email verification',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(160, 0, 160, 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xFFFECD00),
              ),
              child: TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                },
                child: const Text(
                  'Restart',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
