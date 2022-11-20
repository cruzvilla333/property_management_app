import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:training_note_app/designs/buttons/button_designs.dart';
import 'package:training_note_app/services/auth/auth_tools.dart';
import 'package:training_note_app/utilities/dialogs/error_dialog.dart';
import 'package:training_note_app/utilities/routes/app_routes.dart';
import 'package:training_note_app/utilities/routes/auth_route_handling.dart';
import '../designs/textfields/textfield_designs.dart';
import '../services/auth/auth_bloc/auth_bloc.dart';
import '../services/auth/auth_bloc/auth_states.dart';
import '../designs/colors/app_colors.dart';
import '../utilities/dialogs/loading_functions.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        handleLoading(context: context, state: state);
        if (state is AuthStateRegistering) {
          if (state.exception != null) {
            await showErrorDialog(context, state.exception.toString());
          }
        } else {
          handleAuthRouting(context: context, state: state);
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
            backgroundColor: backGroundColor,
            appBar: AppBar(
              title: const Text('Register'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        standartTextFieldDecoration(text: 'Enter your email'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: standartTextFieldDecoration(
                        text: 'Enter your password'),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    style: standardButtonStyle(width: 300),
                    onPressed: () async {
                      attemptRegister(
                          email: _email.text,
                          password: _password.text,
                          context: context);
                    },
                    child: const Text('Register'),
                  ),
                  TextButton(
                      style: standardButtonStyle(width: 300),
                      onPressed: () => context.goNamed(loginPage),
                      child: const Text('Already registered?'))
                ],
              ),
            )),
      ),
    );
  }
}
