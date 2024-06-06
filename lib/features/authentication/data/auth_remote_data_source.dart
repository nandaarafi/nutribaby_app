import 'package:nutribaby_app/features/authentication/model/auth_data_model.dart';
import 'package:nutribaby_app/features/authentication/data/auth_remote_data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e;
    }
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel user =
      await UserService().getUserById(userCredential.user!.uid);
      return user;
    }  catch (e) {
      throw (e);
    }
  }

  Future<UserModel> signUp(
      {required String email,
        required String password,
        required String parentName,
        required String babyName,
        required DateTime birthdate,
        required String gender,
        String role = ''}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      UserModel user = UserModel(
        id: userCredential.user!.uid,
        email: email,
        parentName: parentName,
        babyName: babyName,
        role: 'user',
        birthdate: birthdate,
        gender: gender
      );

      await UserService().setUser(user);

      return user;
    } catch (e) {
      throw (e);
    }
  }


  Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    }  catch (e) {
      throw (e);
    }
  }
}