import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:training_note_app/services/auth/auth_tools.dart';
import 'package:training_note_app/services/auth/auth_bloc/auth_bloc.dart';
import 'package:training_note_app/services/auth/auth_bloc/auth_events.dart';
import 'package:training_note_app/services/auth/auth_bloc/auth_states.dart';
import 'package:training_note_app/utilities/dialogs/error_dialog.dart';
import 'package:training_note_app/utilities/dialogs/loading_functions.dart';
import 'package:training_note_app/utilities/routes/app_routes.dart';
import 'package:training_note_app/utilities/routes/auth_route_handling.dart';

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
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        handleLoading(context: context, state: state);
        if (state is AuthStateLoggedOut) {
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
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.blue.shade600,
          appBar: AppBar(
            title: const Text('Login'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.house_outlined,
                  size: 150,
                  color: Colors.white,
                ),
                const SizedBox(height: 20, width: 10),
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
                      fixedSize: const MaterialStatePropertyAll(Size(300, 10))),
                  onPressed: () async {
                    attemptLogIn(
                      email: _email.text,
                      password: _password.text,
                      context: context,
                    );
                  },
                  child: const Text(
                    'Log in',
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.normal,
                    ),
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
                      fixedSize: const MaterialStatePropertyAll(Size(300, 10))),
                  onPressed: () => context.goNamed(registerPage),
                  child: const Text("Sing up"),
                ),
                TextButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      fixedSize: const MaterialStatePropertyAll(Size(200, 10))),
                  onPressed: () => context.goNamed(passwordResetPage),
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
