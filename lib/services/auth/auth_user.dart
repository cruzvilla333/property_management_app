import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

@immutable
class AuthUser {
  final bool _emailVerified;
  const AuthUser(this._emailVerified);
  bool isEmailVerified() {
    return _emailVerified;
  }

  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
