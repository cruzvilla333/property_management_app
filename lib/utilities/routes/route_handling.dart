import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:training_note_app/views/forgot_password_view.dart';

import '../../services/auth/bloc/auth_states.dart';
import 'app_routes.dart';

void handleRouting({
  required BuildContext context,
  required AuthState state,
}) async {
  if (state is AuthStateVerifyEmail) context.go(verifyEmailPage);
  if (state is AuthStateLoggedIn) context.go(propertyPage);
  if (state is AuthStateLoggedOut) context.go(loginPage);
  if (state is AuthStateRegistering) context.go(registerPage);
  if (state is AuthStateForgotPassword) {
    context.go(loginPage + passwordResetPage);
  }
}
