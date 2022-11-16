import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({this.exception});
}

class AuthStateLoggedIn extends AuthState {
  const AuthStateLoggedIn();
}

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut({
    this.exception,
  });
}

class AuthStateVerifyEmail extends AuthState {
  const AuthStateVerifyEmail();
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;

  const AuthStateForgotPassword({
    required this.exception,
    required this.hasSentEmail,
  });
}

class AuthStateShowLogOut extends AuthState {
  const AuthStateShowLogOut();
}

class AuthStateLoading extends AuthState {
  final String text;
  const AuthStateLoading({required this.text});
}
