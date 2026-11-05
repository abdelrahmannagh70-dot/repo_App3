import 'package:app3/core/networking/api_endpoint.dart';
import 'package:app3/core/services/local/local_Helper.dart';
import 'package:app3/core/utils/app.constans.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  static Dio? _dio;


  static Dio get dio {
    if (_dio == null) {
      init();
    }
    return _dio!;
  }

  static void init() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndPoint.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    );


    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = localHelper.prefs?.get(AppConstans.userToken);

          if (token != null && token.toString().isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    _dio = dio;
  }
}
