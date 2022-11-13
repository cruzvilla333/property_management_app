import 'package:go_router/go_router.dart';
import 'package:training_note_app/views/forgot_password_view.dart';
import 'package:training_note_app/views/login_view.dart';
import 'package:training_note_app/views/notes/notes_view.dart';
import 'package:training_note_app/views/register_view.dart';
import 'package:training_note_app/views/verify_email_view.dart';

const loginPage = '/';
const passwordResetPage = 'password_reset';
const registerPage = '/register';
const verifyEmailPage = '/verify_email';
const propertyPage = '/properties';

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  routes: <GoRoute>[
    GoRoute(
      path: loginPage,
      builder: (context, state) => const LoginView(),
      routes: [
        GoRoute(
          path: passwordResetPage,
          builder: (context, state) => const ForgotPasswordView(),
        ),
      ],
    ),
    GoRoute(
      path: registerPage,
      builder: (context, state) => const RegisterView(),
    ),
    GoRoute(
      path: verifyEmailPage,
      builder: (context, state) => const VerifyEmailView(),
    ),
    GoRoute(
      path: propertyPage,
      builder: (context, state) => const NotesView(),
    ),
  ],
);
