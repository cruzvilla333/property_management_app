import 'package:go_router/go_router.dart';
import 'package:training_note_app/views/authentication/forgot_password_view.dart';
import 'package:training_note_app/views/authentication/login_view.dart';
import 'package:training_note_app/views/main_app_bloc_builder.dart';
import 'package:training_note_app/views/authentication/register_view.dart';
import 'package:training_note_app/views/authentication/verify_email_view.dart';

const loginPage = 'login';
const passwordResetPage = 'password_reset';
const registerPage = 'register';
const verifyEmailPage = 'verify_email';
const propertiesPage = 'properties';
const getOrUpdatePropertyPage = 'property';
const propertyDetailsPage = 'property_details';

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  routes: <GoRoute>[
    GoRoute(
      name: loginPage,
      path: '/',
      builder: (context, state) => const LoginView(),
      routes: [
        GoRoute(
          name: passwordResetPage,
          path: 'password_reset',
          builder: (context, state) => const ForgotPasswordView(),
        ),
      ],
    ),
    GoRoute(
      name: registerPage,
      path: '/register',
      builder: (context, state) => const RegisterView(),
    ),
    GoRoute(
      name: verifyEmailPage,
      path: '/verify_email',
      builder: (context, state) => const VerifyEmailView(),
    ),
    GoRoute(
      name: propertiesPage,
      path: '/properties',
      builder: (context, state) => const PropertiesViewBuilder(),
    ),
  ],
);
