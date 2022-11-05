import 'package:flutter/material.dart';
import 'package:training_note_app/constants/routes.dart';
import 'package:training_note_app/services/auth/auth_service.dart';
import 'package:training_note_app/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter your email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Enter your password'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final user = await AuthService.firebase().login(
                  email: _email.text,
                  password: _password.text,
                );
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    user.isEmailVerified() ? notesRoute : verifyEmailRoute,
                    (route) => false,
                  );
                }
              } catch (e) {
                showErrorDialog(context, e.toString());
              }
            },
            child: const Text('Log in'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text("Sing up"))
        ],
      ),
    );
  }
}
