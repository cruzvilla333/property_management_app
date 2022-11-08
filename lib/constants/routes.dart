import '../views/login_view.dart';
import '../views/notes/create_update_note_view.dart';
import '../views/notes/notes_view.dart';
import '../views/register_view.dart';
import '../views/verify_email_view.dart';

const loginRoute = '/login/';
const registerRoute = '/register/';
const notesRoute = '/notes/';
const verifyEmailRoute = '/verify-email/';
const createOrUpdateNoteRoute = '/notes/new-note/';

final routes = {
  loginRoute: (context) => const LoginView(),
  registerRoute: (context) => const RegisterView(),
  notesRoute: (context) => const NotesView(),
  verifyEmailRoute: (context) => const VerifyEmailView(),
  createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
};
