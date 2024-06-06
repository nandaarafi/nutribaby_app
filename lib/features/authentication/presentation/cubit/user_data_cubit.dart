import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nutribaby_app/features/authentication/data/user_data_data_service.dart';

import '../../model/user_data_model.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  UserDataCubit() : super(UserDataInitial());

  void getAllEmailData() async {
    try{
      print("I am doing good");
      emit(UserDataLoading());
      print("doing something");
      List<UserDataModel> emails = await UserDataService().getAllEmailData();
      emit(UserDataSuccess(emails));
    } catch(e){
      emit(UserDataFailed(e.toString()));
    }
  }

  void getAllUserData() async {
    try{
      emit(UserDataLoading());
      String emails = await UserDataService().getAllUserDataAsCSV();
      emit(UserAllDataSuccess(emails));
    } catch(e){
      emit(UserDataFailed(e.toString()));
    }
  }
}
