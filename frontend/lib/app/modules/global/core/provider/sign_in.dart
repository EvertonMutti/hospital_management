import 'package:dio/dio.dart';
import 'package:hospital_management/app/modules/global/core/model/hospital_model.dart';
import 'package:hospital_management/app/modules/global/core/network/endpoints.dart';
import 'package:hospital_management/app/modules/global/core/network/http_client.dart';

import '../../sign_in/repository.dart';
import '../model/login_model.dart';

class SignInProvider implements SignInRepository {
  final _http = HttpAuthClient().init;

  @override
  Future<LoginModel> getUser(body) async {
    //if (Enviroment.env != 'DEV') {
    try {
      final response = await _http.post(Endpoints.login, data: body);
      return LoginModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if ([404, 400, 503].contains(statusCode)) {
          final message = e.response?.data['detail'] ?? e.message;
          return LoginModel(status: false, detail: message);
        }
      }
      return LoginModel(status: false);
    }
  }

  @override
  Future<HospitalList> getHospital() async {
    try {
      final response = await _http.get(Endpoints.listHospitals);
      return HospitalList.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if ([403, 503].contains(statusCode)) {
          final message = e.response?.data['detail'] ?? e.message;
          return HospitalList(status: false, detail: message);
        }
      }
      return HospitalList(status: false);
    }
  }
}
