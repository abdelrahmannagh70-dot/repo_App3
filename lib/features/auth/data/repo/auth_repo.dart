import 'package:app3/core/networking/dio_factory.dart';
import 'package:app3/core/networking/api_endpoint.dart';
import 'package:app3/core/services/local/local_Helper.dart';
import 'package:app3/core/utils/app.constans.dart';

class AuthRepo {

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {

      final response = await DioFactory.dio?.post(
        ApiEndPoint.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response?.statusCode == 200) {

        String? token = response?.data["data"]["token"];

        await saveToken(token);

        return true;

      } else {
        return false;
      }

    } catch (e) {

      print("Login Error: $e");

      return false;
    }
  }

  Future<void> saveToken(String? token) async {

    await localHelper.prefs?.setString(
      AppConstans.userToken,
      token ?? "",
    );

  }
}