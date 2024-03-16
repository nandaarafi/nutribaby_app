import 'package:nutribaby_app/features/authentication/model/auth_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  CollectionReference _userReference =
  FirebaseFirestore.instance.collection('users');

  Future<void> setUser(UserModel user) async {
    try {
      _userReference.doc(user.id).set({
        'email': user.email,
        'parentName': user.parentName,
        'babyName': user.babyName,
        'role': user.role,
        'birthdate': user.birthdate,
        'gender': user.gender
        // 'balance': user.balance,
      });
    } catch (e) {
      throw e;
    }
  }

  Future<UserModel> getUserById(String id) async {
    try {
      DocumentSnapshot snapshot = await _userReference.doc(id).get();
      return UserModel(
        id: id,
        email: snapshot['email'],
        parentName: snapshot['parentName'],
        babyName: snapshot['babyName'],
        role: snapshot['role'],
          birthdate: (snapshot['birthdate'] as Timestamp).toDate(),
        gender: snapshot['gender']
        // balance: snapshot['balance'],
      );
    } catch (e) {
      throw e;
    }
  }
}
