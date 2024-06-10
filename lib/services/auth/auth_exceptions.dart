// Login Exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

class InvalidCredentialException implements Exception {}

// Register Exceptions
class EmailAlreadyInUseAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// Generic Exceptions
class GenericAuthException implements Exception {
  // final String message;

  // GenericAuthException(this.message);
  // void printMessage() {
  //   print(message);
  // }
}

class UserNotLoggedInAuthException implements Exception {}
