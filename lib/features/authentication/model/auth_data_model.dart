import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String parentName;
  final String babyName;
  final String role;
  final DateTime birthdate;
  final String gender;


  UserModel({
    required this.id,
    required this.email,
    required this.parentName,
    required this.babyName,
    this.role = '',
    required this.birthdate,
    required this.gender,
  });

  @override
  List<Object?> get props => [id, email, parentName,babyName, role];
}