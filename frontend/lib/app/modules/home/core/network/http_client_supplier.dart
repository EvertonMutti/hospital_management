import 'package:dio/dio.dart';
import 'package:hospital_management/app/core/config/config.dart';
import 'package:hospital_management/app/core/services/auth.dart';

class HttpClientHome {
  Dio init = Dio(
    BaseOptions(
      connectTimeout: const Duration(milliseconds: 15000),
      sendTimeout: const Duration(milliseconds: 15000),
      baseUrl: Enviroment.apiBaseUri,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Accept': "*/*",
      },
    ),
  );

  static final HttpClientHome _dioClient = HttpClientHome._internal();

  factory HttpClientHome() {
    _dioClient.init.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String token = AuthService.to.getUser.token!;
          if (token != "") {
            options.headers["Authorization"] = "Bearer $token";
            options.headers["api-key"] = Enviroment.apiKey;
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
            AuthService.to.logoutUser();
          }

          return handler.next(e);
        },
      ),
    );
    return _dioClient;
  }

  HttpClientHome._internal();
}
