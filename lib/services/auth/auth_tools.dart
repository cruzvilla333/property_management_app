import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/auth/auth_exceptions.dart';
import 'package:training_note_app/services/auth/auth_service.dart';
import 'package:training_note_app/services/auth/auth_user.dart';
import 'auth_bloc/auth_bloc.dart';
import 'auth_bloc/auth_events.dart';

void attemptLogIn({
  required String email,
  required String password,
  required BuildContext context,
}) {
  context.read<AuthBloc>().add(
        AuthEventLogIn(
          email,
          password,
        ),
      );
}

Future<void> attemptLogOut({
  required BuildContext context,
}) async {
  context.read<AuthBloc>().add(
        const AuthEventLogOut(),
      );
}

void attemptRegister({
  required String email,
  required String password,
  required BuildContext context,
}) {
  context.read<AuthBloc>().add(
        AuthEventRegister(email, password),
      );
}

AuthUser user() {
  final user = AuthService.firebase().currentUser;
  if (user != null) {
    return user;
  } else {
    throw UserNotLoggedInAuthException();
  }
}
