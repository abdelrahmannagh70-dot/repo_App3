import 'package:app3/core/networking/api_endpoint.dart';
import 'package:app3/core/networking/dio_factory.dart';

import '../model/profile_response_model.dart';

class ProfileRepo {


 static Future<ProfileDataModel?> getProfileData()async{
    try{
      final response = await DioFactory.dio?.get(ApiEndPoint.Profile);
      if(response?.statusCode==200){
        ProfileResponseModel profileData =ProfileResponseModel.fromJson(response?.data);
        return profileData.data;

      }else{
        return null;
      }

    }catch(e){
      return null;
    }
  }
}