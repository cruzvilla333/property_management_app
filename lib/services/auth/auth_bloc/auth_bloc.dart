import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/auth/auth_provider.dart';
import 'package:training_note_app/services/auth/auth_bloc/auth_states.dart';
import 'package:training_note_app/services/auth/auth_bloc/auth_events.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(
          const AuthStateUninitialized(),
        ) {
    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
            ),
          );
        } else if (!user.isEmailVerified) {
          emit(const AuthStateVerifyEmail());
        } else {
          emit(
            AuthStateLoggedIn(
              user: user,
            ),
          );
        }
      },
    );
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(
          const AuthStateLoading(
            text: 'Loggin in...',
          ),
        );
        try {
          final user = await provider.logIn(
              email: event.email, password: event.password);
          if (!user.isEmailVerified) {
            provider.logOut();
            emit(const AuthStateVerifyEmail());
          } else {
            emit(AuthStateLoggedIn(user: user));
          }
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(
              exception: e,
            ),
          );
        }
      },
    );
    on<AuthEventLogOut>(
      (event, emit) async {
        emit(
          const AuthStateLoading(
            text: 'Logging out...',
          ),
        );
        try {
          await provider.logOut();
          emit(
            const AuthStateLoggedOut(
              exception: null,
            ),
          );
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(
              exception: e,
            ),
          );
        }
      },
    );
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await provider.sendEmailVerification();
        emit(state);
      },
    );
    on<AuthEventShouldRegister>(
      (event, emit) async {
        emit(
          const AuthStateRegistering(
            exception: null,
          ),
        );
      },
    );
    on<AuthEventRegister>(
      (event, emit) async {
        emit(
          const AuthStateLoading(
            text: 'Registering...',
          ),
        );
        try {
          await provider.createUser(
            email: event.email,
            password: event.password,
          );
          await provider.sendEmailVerification();
          emit(
            const AuthStateVerifyEmail(),
          );
        } on Exception catch (e) {
          emit(
            AuthStateRegistering(
              exception: e,
            ),
          );
        }
      },
    );
    on<AuthEventForgotPassword>(
      (event, emit) async {
        emit(
          const AuthStateForgotPassword(
            exception: null,
            hasSentEmail: false,
          ),
        );
        final email = event.email;
        if (email == null) {
          return;
        }
        emit(
          const AuthStateForgotPassword(
            exception: null,
            hasSentEmail: false,
          ),
        );
        try {
          await provider.sendPasswordReset(email: email);
          emit(
            const AuthStateForgotPassword(
              exception: null,
              hasSentEmail: true,
            ),
          );
        } on Exception catch (e) {
          emit(
            AuthStateForgotPassword(
              exception: e,
              hasSentEmail: false,
            ),
          );
        }
      },
    );
    on<AuthEventShowLogOut>(
      (event, emit) => emit(const AuthStateShowLogOut()),
    );
  }
}
