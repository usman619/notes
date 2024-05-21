// Login Exceptions
class UserNotFoundException implements Exception {}

class WrongPasswordException implements Exception {}

class InvalidCredentialException implements Exception {}

// Register Exceptions
class EmailAlreadyInUseException implements Exception {}

class WeakPasswordException implements Exception {}

class InvalidEmailException implements Exception {}

// Generic Exceptions
class GenericException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
