import 'package:app3/features/profile/data/repo/profile_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:meta/meta.dart';

import '../model/profile_response_model.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());



  getProfileData()async{
    emit(GetProfileLoading());
    final response=await ProfileRepo.getProfileData();
    if(response is ProfileDataModel){
      emit(GetProfileSuccess(response));
    }else{
      emit(GetProfileError());
    }

  }
}
