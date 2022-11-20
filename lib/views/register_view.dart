import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:training_note_app/services/auth/auth_tools.dart';
import 'package:training_note_app/utilities/dialogs/error_dialog.dart';
import 'package:training_note_app/utilities/routes/app_routes.dart';
import 'package:training_note_app/utilities/routes/auth_route_handling.dart';
import '../services/auth/auth_bloc/auth_bloc.dart';
import '../services/auth/auth_bloc/auth_states.dart';
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
            backgroundColor: Colors.blue.shade600,
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
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100)),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            const MaterialStatePropertyAll(Colors.white),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        fixedSize:
                            const MaterialStatePropertyAll(Size(300, 10))),
                    onPressed: () async {
                      attemptRegister(
                          email: _email.text,
                          password: _password.text,
                          context: context);
                    },
                    child: const Text('Register'),
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
                          fixedSize:
                              const MaterialStatePropertyAll(Size(300, 10))),
                      onPressed: () => context.goNamed(loginPage),
                      child: const Text('Already registered?'))
                ],
              ),
            )),
      ),
    );
  }
}
