import 'package:flutter/material.dart';
import 'package:training_note_app/constants/routes.dart';
import 'package:training_note_app/constants/routes_tools.dart';
import 'package:training_note_app/services/auth/auth_service.dart';
import 'package:training_note_app/services/auth/auth_tools.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify email')),
      body: Column(children: [
        const Text('A verification email has been sent to your address'),
        TextButton(
          onPressed: () async {
            await AuthService.firebase().sendEmailVerification();
          },
          child: const Text('Resend email'),
        ),
        TextButton(
          onPressed: () {
            moveToPage(
              context: context,
              route: loginRoute,
            );
          },
          child: const Text('Verified'),
        ),
        TextButton(
          onPressed: () async {
            await tryFirebaseLogOut(context: context);
            moveToPage(
              context: context,
              route: loginRoute,
            );
          },
          child: const Text('Log out'),
        ),
      ]),
    );
  }
}
