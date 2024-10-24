import 'package:hospital_management/app/modules/global/core/model/hospital_model.dart';

import '../core/model/login_model.dart';

abstract class SignInRepository {
  Future<LoginModel> getUser(body);
  Future<HospitalList> getHospital();
}
