import 'package:flutter/material.dart';
import 'package:training_note_app/constants/routes.dart';
import 'package:training_note_app/services/auth/auth_service.dart';
import 'package:training_note_app/views/login_view.dart';
import 'package:training_note_app/views/notes_view.dart';
import 'package:training_note_app/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: routes,
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              return user.isEmailVerified
                  ? const NotesView()
                  : const VerifyEmailView();
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
