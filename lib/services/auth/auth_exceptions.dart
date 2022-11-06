//Login exceptions

class UserNotFoundAuthException implements Exception {
  @override
  String toString() => 'User not found';
}

class WrongPasswordAuthException implements Exception {
  @override
  String toString() => 'Wrong password';
}

// Register exception

class WeakPasswordAuthException implements Exception {
  @override
  String toString() => 'Weak password';
}

class EmailAlreadyInUseAuthException implements Exception {
  @override
  String toString() => 'Email already in use';
}

class InvalidEmailAuthException implements Exception {
  @override
  String toString() => 'Invalid email';
}

//Generic exceptions

class GenericAuthException implements Exception {
  @override
  String toString() {
    return 'Something went wrong';
  }
}

class UserNotLoggedInAuthException implements Exception {
  @override
  String toString() => 'User not logged in';
}

final Map<String, Exception> exceptions = {
  'user-not-found': UserNotFoundAuthException(),
  'wrong-password': WrongPasswordAuthException(),
  'invalid-email': InvalidEmailAuthException(),
  'weak-password': WeakPasswordAuthException(),
  'email-already-in-use': EmailAlreadyInUseAuthException(),
};
