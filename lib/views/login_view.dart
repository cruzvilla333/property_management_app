import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:training_note_app/designs/buttons/button_designs.dart';
import 'package:training_note_app/services/auth/auth_tools.dart';
import 'package:training_note_app/services/auth/auth_bloc/auth_bloc.dart';
import 'package:training_note_app/services/auth/auth_bloc/auth_events.dart';
import 'package:training_note_app/services/auth/auth_bloc/auth_states.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_events.dart';
import 'package:training_note_app/utilities/dialogs/error_dialog.dart';
import 'package:training_note_app/utilities/dialogs/loading_functions.dart';
import 'package:training_note_app/utilities/navigation/navigation_utilities.dart';
import 'package:training_note_app/utilities/routes/app_routes.dart';
import 'package:training_note_app/utilities/routes/auth_route_handling.dart';
import 'package:training_note_app/views/forgot_password_view.dart';
import 'package:training_note_app/views/register_view.dart';

import '../designs/colors/app_colors.dart';
import '../designs/textfields/textfield_designs.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  //bool _secureState = true;
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
          backgroundColor: backGroundColor,
          appBar: AppBar(
            backgroundColor: appBarColor,
            title: Text(
              'Please login',
              style: TextStyle(color: mainAppTextColor),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 70),
                const Icon(
                  Icons.house_outlined,
                  size: 150,
                  color: houseIcon,
                ),
                const SizedBox(height: 20, width: 10),
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: standardTextFieldDecoration(
                      text: 'Enter your email',
                      endIcon: const Icon(Icons.email)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: standardTextFieldDecoration(
                      text: 'Enter your password',
                      endIcon: const Icon(Icons.security)),
                ),
                const SizedBox(height: 20),
                TextButton(
                  style: standardButtonStyle(width: 300),
                  onPressed: () async {
                    attemptLogIn(
                      email: _email.text,
                      password: _password.text,
                      context: context,
                    );
                  },
                  child: Text(
                    'Log in',
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.normal,
                      color: mainAppTextColor,
                    ),
                  ),
                ),
                TextButton(
                  style: standardButtonStyle(width: 300),
                  onPressed: () => context.goNamed(registerPage),
                  child: Text(
                    "Sing up",
                    style: TextStyle(color: mainAppTextColor),
                  ),
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
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(color: mainAppTextColor),
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
