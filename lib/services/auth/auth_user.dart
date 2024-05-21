import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  const AuthUser(this.isEmailVerified);

  // Making a copy of the firebase user email verified to our AuthUser object
  // To make sure we are not exposing the firebase user object and it's properties
  // to the UI
  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
