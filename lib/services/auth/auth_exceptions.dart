//Login exceptions

class UserNotFoundAuthException implements Exception {
  @override
  String toString() {
    return 'User not found';
  }
}

class WrongPasswordAuthException implements Exception {
  @override
  String toString() {
    return 'Wrong password';
  }
}

// Register exception

class WeakPasswordAuthException implements Exception {
  @override
  String toString() {
    return 'Weak password';
  }
}

class EmailAlreadyInUseAuthException implements Exception {
  @override
  String toString() {
    return 'Email already in use';
  }
}

class InvalidEmailAuthException implements Exception {
  @override
  String toString() {
    return 'Invalid email';
  }
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
  String toString() {
    return 'User not logged in';
  }
}
