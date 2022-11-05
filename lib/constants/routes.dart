import '../main.dart';
import '../views/login_view.dart';
import '../views/register_view.dart';
import '../views/verify_email_view.dart';

const loginRoute = '/login/';
const registerRoute = '/register/';
const notesRoute = '/notes/';
const verifyEmailRoute = '/verify-email/';

final routes = {
  loginRoute: (context) => const LoginView(),
  registerRoute: (context) => const RegisterView(),
  notesRoute: (context) => const NotesView(),
  verifyEmailRoute: (context) => const VerifyEmailView(),
};
