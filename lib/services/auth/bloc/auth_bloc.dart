import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/auth/auth_provider.dart';
import 'package:training_note_app/services/auth/bloc/auth_states.dart';
import 'package:training_note_app/services/auth/bloc/auth_events.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()) {
    on<AuthEventInitialize>(
      (event, emit) async {
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
          emit(const AuthStateVerifyEmail());
        } else {
          emit(AuthStateLoggedIn(user));
        }
      },
    );
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: true,
          ),
        );
        try {
          final user = await provider.logIn(
              email: event.email, password: event.password);
          if (!user.isEmailVerified) {
            emit(
              const AuthStateLoggedOut(
                exception: null,
                isLoading: false,
              ),
            );
            emit(const AuthStateVerifyEmail());
          } else {
            emit(
              const AuthStateLoggedOut(
                exception: null,
                isLoading: false,
              ),
            );
            emit(AuthStateLoggedIn(user));
          }
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(
              exception: e,
              isLoading: false,
            ),
          );
        }
      },
    );
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
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
        emit(const AuthStateRegistering(null));
      },
    );
    on<AuthEventRegister>(
      (event, emit) async {
        try {
          await provider.createUser(
            email: event.email,
            password: event.password,
          );
          provider.sendEmailVerification();
          emit(const AuthStateVerifyEmail());
        } on Exception catch (e) {
          emit(AuthStateRegistering(e));
        }
      },
    );
  }
}
