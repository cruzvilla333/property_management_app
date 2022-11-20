import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:training_note_app/services/auth/auth_bloc/auth_bloc.dart';
import 'package:training_note_app/services/auth/auth_bloc/auth_events.dart';
import 'package:training_note_app/services/auth/auth_bloc/auth_states.dart';
import 'package:training_note_app/utilities/dialogs/loading_functions.dart';
import 'package:training_note_app/utilities/routes/app_routes.dart';
import 'package:training_note_app/utilities/routes/auth_route_handling.dart';

import '../utilities/app_colors.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        handleLoading(context: context, state: state);
        handleAuthRouting(context: context, state: state);
      },
      child: Scaffold(
        backgroundColor: backGroundColor,
        appBar: AppBar(title: const Text('Verify email')),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'A verification email has been sent to your email address',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        const MaterialStatePropertyAll(Colors.white),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    fixedSize: const MaterialStatePropertyAll(Size(200, 10))),
                onPressed: () async {
                  context.read<AuthBloc>().add(
                        const AuthEventSendEmailVerification(),
                      );
                },
                child: const Text(
                  'Resend email',
                  style: TextStyle(),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        const MaterialStatePropertyAll(Colors.white),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    fixedSize: const MaterialStatePropertyAll(Size(200, 10))),
                onPressed: () => context.goNamed(loginPage),
                child: const Text(
                  'Verified?',
                  style: TextStyle(),
                ),
              ),
            ]),
      ),
    );
  }
}
