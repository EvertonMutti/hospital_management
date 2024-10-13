

import 'package:hospital_management/app/core/config/config.dart';
import 'package:hospital_management/app/modules/global/core/network/endpoints.dart';
import 'package:hospital_management/app/modules/global/core/network/http_client.dart';

import '../../sign_in/repository.dart';
import '../model/login_model.dart';

class SignInProvider implements SignInRepository {
  final _http = HttpAuthClient().init;

  @override
  Future<LoginModel> getUser(body) async {
    if (Enviroment.env != 'DEV') {
      final response = await _http.post(Endpoints.login, data: body);
      return LoginModel.fromJson(response.data);

    }   
    return LoginModel.fromJson({
      "sub": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJqb2FvZGFzaWx2YUBleGFtcGxlLmNvbSIsIm5hbWUiOiJKb1x1MDBlM28iLCJleHAiOjE3MjQxMjE1MTN9.Pbf92DQTfAysLci1KSTPxnk-C2TEY2rbAkHU5q-tHxk"
    });
  }
}
