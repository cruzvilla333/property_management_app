//Login exceptions

class UserNotFoundAuthException implements Exception {
  @override
  String toString() => 'This user cannot be found';
}

class WrongPasswordAuthException implements Exception {
  @override
  String toString() => 'Incorrect email or password';
}

// Register exception

class WeakPasswordAuthException implements Exception {
  @override
  String toString() => 'Password too weak';
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
  'auth/invalid-email': InvalidEmailAuthException(),
  'auth/user-not-found': UserNotFoundAuthException(),
};
