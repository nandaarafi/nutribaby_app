

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthExceptionCustom implements Exception {
  final String message;

  FirebaseAuthExceptionCustom(this.message);

  factory FirebaseAuthExceptionCustom.fromFirebaseException(FirebaseAuthException e) {
    switch (e.code) {
      case '[firebase_auth/invalid-credential]':
        return FirebaseAuthExceptionCustom('Wrong Password or Email');
      case '[firebase_auth/too-many-requests]':
        return FirebaseAuthExceptionCustom('Too many login attempts. Please try again later.');
      case 'email-already-in-use':
        return FirebaseAuthExceptionCustom('The email address is already in use by another account.');
      case '[firebase_auth/invalid-email]':
        return FirebaseAuthExceptionCustom('The email address is not valid.');
      case 'weak-password':
        return FirebaseAuthExceptionCustom('The password is too weak.');
      default:
        return FirebaseAuthExceptionCustom('An error occurred. Please try again.');
    }
  }

  @override
  String toString() => 'FirebaseAuthExceptionCustom: $message';
}

class CustomErrorMessages {
  static const String requiredField = 'Please fill in all required fields.';
  static const String emailEmpty = 'Please fill the email.';
  static const String invalidEmail = 'The email address is not valid.';
  static const String weakPassword = 'The password is too weak.';
  static const String emailInUse = 'The email address is already in use by another account.';
// Add more error messages as needed
}

class EmptyDataListException implements Exception {
  final String message;

  EmptyDataListException(this.message);

  @override
  String toString() => message;
}