import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutribaby_app/features/authentication/model/auth_data_model.dart';
import 'package:nutribaby_app/features/authentication/data/auth_remote_data_source.dart';
import 'package:nutribaby_app/features/authentication/data/auth_remote_data_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void resetPassword(String email) async {
    try {
      emit(AuthLoading());
      await AuthService().resetPassword(email); // Implement resetPassword in AuthService
      emit(PasswordResetSent());
    } on FirebaseAuthException catch (e) {
      String errorMessage = _handleAuthException(e);
      emit(AuthFailed(errorMessage));
    }
  }

  void signInRole({required String email, required String password}) async {
    try {
      emit(AuthLoading());
      UserModel user = await AuthService().signIn(
        email: email,
        password: password,
      );
      emit(AuthSuccess(user));
    } on FirebaseAuthException catch (e) {
      String errorMessage = _handleAuthException(e);
      emit(AuthFailed((errorMessage)));
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String parentName,
    required String babyName,
    required DateTime birthdate,
    required String gender,
    String role = '',
  }) async {
    try {
      emit(AuthLoading());

      UserModel user = await AuthService().signUp(
        email: email,
        password: password,
        parentName: parentName,
        babyName: babyName,
        birthdate: birthdate,
        gender: gender
      );

      emit(AuthSuccess(user));
    } on FirebaseAuthException catch (e) {
      String errorMessage = _handleAuthException(e);

      // If an error occurs during sign-up, emit AuthFailed state with custom error message
      emit(AuthFailed(errorMessage));
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    // Handle specific Firebase Authentication error codes and return custom error messages
    switch (e.code) {
      case 'invalid-credential':
        return 'Wrong Password or Email';
      case 'user-not-found':
        return 'No user found with this email. Please check the email address.';
      case 'too-many-requests':
        return 'Too many request, Please Try Again';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak.';
    // Add more cases as needed for other error codes
      default:
        return e.code;
        // return 'An error occurred. Please try again.';
    }
  }

  void signOut() async {
    try {
      await AuthService().signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  void getCurrentUser(String id) async {
    try {
      UserModel user = await UserService().getUserById(id);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }
}
