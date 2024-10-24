import 'package:hospital_management/app/modules/global/core/model/hospital_model.dart';
import 'package:hospital_management/app/modules/global/core/model/signup_model.dart';
import 'package:hospital_management/app/modules/global/core/model/signup_responseModel.dart';

import '../core/model/login_model.dart';

abstract class SignInRepository {
  Future<LoginModel> getUser(body);
  Future<HospitalList> getHospital();
  Future<SignupResponseModel> registerUser(SignupModel body); 
}
