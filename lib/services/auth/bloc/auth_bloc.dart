import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/auth/auth_provider.dart';
import 'package:training_note_app/services/auth/bloc/auth_states.dart';
import 'package:training_note_app/services/auth/bloc/auth_events.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut(null));
        } else if (!user.isEmailVerified) {
          emit(const AuthStateVerifyEmail());
        } else {
          emit(AuthStateLoggedIn(user));
        }
      },
    );
    on<AuthEventLogIn>(
      (event, emit) async {
        try {
          final user = await provider.logIn(
              email: event.email, password: event.password);
          if (!user.isEmailVerified) {
            emit(const AuthStateVerifyEmail());
          } else {
            emit(AuthStateLoggedIn(user));
          }
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(e));
        }
      },
    );
    on<AuthEventLogOut>(
      (event, emit) async {
        emit(const AuthStateLoading());
        try {
          await provider.logOut();
          emit(const AuthStateLoggedOut(null));
        } on Exception {
          rethrow;
        }
      },
    );
  }
}
