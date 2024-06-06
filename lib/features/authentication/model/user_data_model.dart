import 'package:equatable/equatable.dart';

class UserDataModel extends Equatable {
  final String email;
  final String docId;


  UserDataModel({
    required this.email,
    required this.docId,
  });

  @override
  List<Object?> get props => [email, docId];
}