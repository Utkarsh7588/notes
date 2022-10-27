import 'package:bloc/bloc.dart';
import 'package:notes/services/auth/auth_provider.dart';

import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/auth/bloc/auth_state.dart';
import 'package:notes/utilities/dialogs/verify_email_sent_dialog.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        try {
          emit(
            const AuthStateNeedsVerification(
              exception: null,
              isLoading: true,
            ),
          );
          await provider.sendEmailVerification();

          emit(
            const AuthStateNeedsVerification(exception: null, isLoading: false),
          );
        } on Exception catch (e) {
          emit(
            AuthStateNeedsVerification(exception: e, isLoading: false),
          );
        }
      },
    );
    on<AuthEventForgotPassword>(
      (event, emit) async {
        emit(const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: false,
        ));
        final email = event.email;
        if (email == null) {
          return;
        }
        emit(const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: true,
        ));
        bool didSendEmail;
        Exception? exception;
        try {
          await provider.sendPasswordReset(toEmail: email);
          didSendEmail = true;
          exception = null;
        } on Exception catch (e) {
          didSendEmail = false;
          exception = e;
        }
        emit(AuthStateForgotPassword(
          exception: exception,
          hasSentEmail: didSendEmail,
          isLoading: false,
        ));
      },
    );
    on<AuthEventRegister>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;
        try {
          emit(
            const AuthStateRegistering(
              exception: null,
              isLoading: true,
            ),
          );
          await provider.createUser(
            email: email,
            password: password,
          );

          await provider.sendEmailVerification();
          emit(const AuthStateNeedsVerification(
              exception: null, isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateRegistering(
            exception: e,
            isLoading: false,
          ));
        }
      },
    );
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(
          exception: null,
          isLoading: false,
        ));
      } else {
        emit(AuthStateLoggedIn(
          user: user,
          isLaoding: false,
        ));
      }
    });
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: true,
            loadingText: 'Please wait',
          ),
        );
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.logIn(
            email: email,
            password: password,
          );
          if (!user.isEmailVerified) {
            emit(
              const AuthStateLoggedOut(
                exception: null,
                isLoading: false,
              ),
            );
            emit(const AuthStateNeedsVerification(
                exception: null, isLoading: false));
          } else {
            emit(
              const AuthStateLoggedOut(
                exception: null,
                isLoading: false,
              ),
            );
          }
          if (user.isEmailVerified) {
            emit(AuthStateLoggedIn(
              user: user,
              isLaoding: false,
            ));
          }
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );
    on<AuthEventLogOut>((event, emit) async {
      try {
        final user = provider.currentUser;
        if (state is AuthStateLoggedIn) {
          emit(AuthStateLoggedIn(
            user: user!,
            isLaoding: true,
          ));
        }
        await provider.logOut();
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
    on<AuthEventNoteCreated>((event, emit) {
      final user = provider.currentUser;
      emit(
        AuthStateLoggedIn(user: user!, isLaoding: false),
      );
    });
    on<AuthEventShouldRegister>(
      (event, emit) {
        try {
          emit(const AuthStateRegistering(
            exception: null,
            isLoading: false,
          ));
        } on Exception catch (e) {
          emit(AuthStateRegistering(
            exception: e,
            isLoading: false,
          ));
        }
      },
    );
    on<AuthEventCreateNote>((event, emit) {
      emit(const AuthStateCreateNote(isloading: false));
    });
  }
}
