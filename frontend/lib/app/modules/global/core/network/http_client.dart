import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/core/config/config.dart';
import 'package:hospital_management/app/core/global_widgets/snackbar.dart';
import 'package:hospital_management/app/core/services/auth.dart';
import 'package:hospital_management/app/modules/global/sign_in/controller.dart';


final controller = Get.find<SignInController>();

class HttpAuthClient {
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
        'api-key': Enviroment.apiKey,
      },
    ),
  );

  static final HttpAuthClient _dioClient = HttpAuthClient._internal();

  factory HttpAuthClient() {
    _dioClient.init.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String token = AuthService.to.getUser.token ?? "";

          if (token != "") {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
            AuthService.to.logoutUser();
          }

          if (e.response!.statusCode! >= 500) {
            SnackBarApp.body(
              "Ops!",
              "Erro ${e.response!.statusCode!}: ${e.response!.statusMessage!}",
            );
          }
          return handler.next(e);
        },
      ),
    );
    return _dioClient;
  }

  HttpAuthClient._internal();
}
