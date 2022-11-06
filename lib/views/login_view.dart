import 'package:flutter/material.dart';
import 'package:training_note_app/constants/routes.dart';
import 'package:training_note_app/constants/routes_tools.dart';
import 'package:training_note_app/services/auth/auth_tools.dart';

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
              final user = await tryFirebaseLogIn(
                  email: _email.text,
                  password: _password.text,
                  context: context);
              moveToPage(
                context: context,
                route: user.isEmailVerified ? notesRoute : verifyEmailRoute,
              );
            },
            child: const Text('Log in'),
          ),
          TextButton(
              onPressed: () {
                moveToPage(
                  context: context,
                  route: registerRoute,
                );
              },
              child: const Text("Sing up"))
        ],
      ),
    );
  }
}
