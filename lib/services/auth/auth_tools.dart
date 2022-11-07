import 'package:flutter/material.dart';
import 'package:training_note_app/services/auth/auth_exceptions.dart';
import 'package:training_note_app/services/auth/auth_service.dart';
import 'package:training_note_app/services/auth/auth_user.dart';
import '../../utilities/dialogs/error_dialog.dart';

Future<AuthUser> tryFirebaseLogIn({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  try {
    final user = await AuthService.firebase().logIn(
      email: email,
      password: password,
    );
    return user;
  } catch (e) {
    await showErrorDialog(context, e.toString());
    rethrow;
  }
}

Future<void> tryFirebaseLogOut({
  required BuildContext context,
}) async {
  try {
    await AuthService.firebase().logOut();
  } catch (e) {
    await showErrorDialog(context, e.toString());
    rethrow;
  }
}

Future<AuthUser> tryFirebaseRegister({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  try {
    final user = await AuthService.firebase().createUser(
      email: email,
      password: password,
    );
    await AuthService.firebase().sendEmailVerification();
    return user;
  } catch (e) {
    await showErrorDialog(context, e.toString());
    rethrow;
  }
}

AuthUser user() {
  final user = AuthService.firebase().currentUser;
  if (user != null) {
    return user;
  } else {
    throw UserNotLoggedInAuthException();
  }
}
