import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as tools show log;

import 'package:training_note_app/constants/routes.dart';
import 'package:training_note_app/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        appBar: AppBar(
          title: const Text('Register'),
        ),
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
              decoration:
                  const InputDecoration(hintText: 'Enter your password'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final userInstance = FirebaseAuth.instance;
                  await userInstance.createUserWithEmailAndPassword(
                      email: _email.text, password: _password.text);
                  await userInstance.currentUser?.sendEmailVerification();
                  if (mounted) {
                    Navigator.of(context).pushNamed(verifyEmailRoute);
                  }
                } on FirebaseAuthException catch (e) {
                  switch (e.code) {
                    case 'weak-password':
                      await showErrorDialog(context, 'Weak password');
                      return;
                    case 'email-already-in-use':
                      await showErrorDialog(context, 'Email already in use');
                      return;
                    case 'invalid-email':
                      await showErrorDialog(context, 'Invalid email');
                      return;
                    default:
                      showErrorDialog(context, 'Error: ${e.code}');
                  }
                } catch (e) {
                  await showErrorDialog(context, e.toString());
                }
              },
              child: const Text('Register'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (route) => false,
                  );
                },
                child: const Text('Already registered?'))
          ],
        ));
  }
}
