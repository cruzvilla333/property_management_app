import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/constants/routes.dart';
import 'package:training_note_app/helpers/loading/loading_screen.dart';
import 'package:training_note_app/services/auth/auth_service.dart';
import 'package:training_note_app/services/auth/bloc/auth_bloc.dart';
import 'package:training_note_app/services/auth/bloc/auth_events.dart';
import 'package:training_note_app/services/auth/bloc/auth_states.dart';
import 'package:training_note_app/views/login_view.dart';
import 'package:training_note_app/views/notes/notes_view.dart';
import 'package:training_note_app/views/register_view.dart';
import 'package:training_note_app/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(AuthService.firebase()),
        child: const HomePage(),
      ),
      routes: routes,
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateRegistering) {
          return const RegisterView();
        }
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        }
        if (state is AuthStateVerifyEmail) {
          return const VerifyEmailView();
        }
        if (state is AuthStateLoggedOut) {
          return const LoginView();
        }
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      },
    );
  }
}
