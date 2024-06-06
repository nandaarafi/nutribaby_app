part of 'user_data_cubit.dart';

abstract class UserDataState extends Equatable {
  const UserDataState();

  @override
  List<Object> get props => [];
}

class UserDataInitial extends UserDataState {}

class UserDataLoading extends UserDataState {}

class UserDataSuccess extends UserDataState {
  final List<UserDataModel> emails;

  const UserDataSuccess(this.emails);

  @override
  List<Object> get props => [emails];
}

class UserAllDataSuccess extends UserDataState {
  final String emails;

  const UserAllDataSuccess(this.emails);

  @override
  List<Object> get props => [emails];
}

class UserDataFailed extends UserDataState {
  final String error;

  UserDataFailed(this.error);

  @override
  List<Object> get props => [error];
}