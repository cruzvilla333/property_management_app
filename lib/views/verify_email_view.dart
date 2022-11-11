import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/auth/bloc/auth_bloc.dart';
import 'package:training_note_app/services/auth/bloc/auth_events.dart';

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
            context.read<AuthBloc>().add(
                  const AuthEventSendEmailVerification(),
                );
          },
          child: const Text('Resend email'),
        ),
        TextButton(
          onPressed: () {
            context.read<AuthBloc>().add(
                  const AuthEventLogOut(),
                );
          },
          child: const Text('Verified?'),
        ),
      ]),
    );
  }
}
