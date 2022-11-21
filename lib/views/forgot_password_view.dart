import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/designs/buttons/button_designs.dart';
import 'package:training_note_app/designs/colors/app_colors.dart';
import 'package:training_note_app/utilities/dialogs/error_dialog.dart';
import 'package:training_note_app/utilities/dialogs/loading_functions.dart';
import 'package:training_note_app/utilities/dialogs/password_reset_email_sent_dialog.dart';

import '../designs/textfields/textfield_designs.dart';
import '../services/auth/auth_bloc/auth_bloc.dart';
import '../services/auth/auth_bloc/auth_events.dart';
import '../services/auth/auth_bloc/auth_states.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        handleLoading(context: context, state: state);

        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null && mounted) {
            await showErrorDialog(context, state.exception.toString());
          }
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: mainAppBackGroundColor,
          appBar: AppBar(
            title: const Text('Forgot Password'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              const SizedBox(height: 200),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                controller: _controller,
                decoration:
                    standardTextFieldDecoration(text: 'Your email here'),
              ),
              const SizedBox(height: 20),
              TextButton(
                style: standardButtonStyle(width: 300),
                onPressed: () {
                  context.read<AuthBloc>().add(
                        AuthEventForgotPassword(
                          email: _controller.text,
                        ),
                      );
                },
                child: const Text('Send password reset email'),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
