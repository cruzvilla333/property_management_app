import 'package:go_router/go_router.dart';
import 'package:training_note_app/views/forgot_password_view.dart';
import 'package:training_note_app/views/login_view.dart';
import 'package:training_note_app/views/properties/properties_view.dart';
import 'package:training_note_app/views/register_view.dart';
import 'package:training_note_app/views/verify_email_view.dart';

const loginPage = 'login';
const passwordResetPage = 'password_reset';
const registerPage = 'register';
const verifyEmailPage = 'verify_email';
const propertiesPage = 'properties';
const getOrUpdatePropertyPage = 'property';

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
      builder: (context, state) => const PropertiesView(),
      // routes: [
      //   GoRoute(
      //     name: getOrUpdatePropertyPage,
      //     path: 'property',
      //     builder: (context, state) => const CreateUpdatePropertyView(),
      //   ),
      // ],
    ),
  ],
);
