import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth/auth_bloc/auth_states.dart';
import 'app_routes.dart';

void handleAuthRouting({
  required BuildContext context,
  required AuthState state,
}) async {
  if (state is AuthStateVerifyEmail) context.goNamed(verifyEmailPage);
  if (state is AuthStateLoggedIn) context.goNamed(propertyPage);
  if (state is AuthStateLoggedOut) context.goNamed(loginPage);
  if (state is AuthStateRegistering) context.goNamed(registerPage);
  if (state is AuthStateForgotPassword) context.goNamed(passwordResetPage);
}
