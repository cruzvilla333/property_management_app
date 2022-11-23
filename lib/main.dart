import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/designs/colors/app_colors.dart';
import 'package:training_note_app/services/auth/auth_service.dart';
import 'package:training_note_app/services/auth/auth_bloc/auth_bloc.dart';
import 'package:training_note_app/services/auth/auth_bloc/auth_events.dart';
import 'package:training_note_app/services/auth/auth_bloc/auth_states.dart';
import 'package:training_note_app/services/crud_services/cloud/firebase_cloud_storage.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_bloc.dart';
import 'package:training_note_app/utilities/routes/app_routes.dart';
import 'package:training_note_app/views/authentication/forgot_password_view.dart';
import 'package:training_note_app/views/authentication/login_view.dart';
import 'package:training_note_app/views/main_app_bloc_builder.dart';
import 'package:training_note_app/views/authentication/register_view.dart';
import 'package:training_note_app/views/authentication/verify_email_view.dart';

import 'helpers/loading/loading_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(AuthService.firebase()),
        ),
        BlocProvider<CrudBloc>(
          create: (context) => CrudBloc(FirebaseCloudStorage()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Router test',
        theme: ThemeData(primarySwatch: generateMaterialColor(Colors.black)),
        routerConfig: router,
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateLoading) {
          LoadingScreen().show(
            context: context,
            text: state.text,
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        }
        if (state is AuthStateRegistering) {
          return const RegisterView();
        }
        if (state is AuthStateLoggedIn) {
          return const PropertiesViewBuilder();
        }
        if (state is AuthStateVerifyEmail) {
          return const VerifyEmailView();
        }
        if (state is AuthStateLoggedOut) {
          return const LoginView();
        }
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      },
    );
  }
}
