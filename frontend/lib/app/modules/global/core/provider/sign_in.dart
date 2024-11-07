import 'package:dio/dio.dart';
import 'package:hospital_management/app/modules/global/core/model/hospital_model.dart';
import 'package:hospital_management/app/modules/global/core/model/signup_model.dart';
import 'package:hospital_management/app/modules/global/core/model/signup_responseModel.dart';
import 'package:hospital_management/app/modules/global/core/network/endpoints.dart';
import 'package:hospital_management/app/modules/global/core/network/http_client.dart';

import '../../sign_in/repository.dart';
import '../model/login_model.dart';

class SignInProvider implements SignInRepository {
  final _http = HttpAuthClient().init;

  @override
  Future<LoginModel> getUser(body) async {
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
  Future<SignupResponseModel> registerUser(SignupModel body) async {
    try {
      final response = await _http.post(Endpoints.signup, data:body);
      return SignupResponseModel.fromJson(response.data);
    } catch (error) {
      if (error is DioException) {
        final statusCode = error.response?.statusCode;
        if ([404, 400, 409, 503].contains(statusCode)) {
          final message = error.response?.data['detail'] ?? error.message;
          return SignupResponseModel(status: false, detail: message);
        }
      }
      return SignupResponseModel(status: false);
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
        if ([503].contains(statusCode)) {
          final message = e.response?.data['detail'] ?? e.message;
          return HospitalList(status: false, detail: message);
        }
      }
      return HospitalList(status: false);
    }
  }
}
