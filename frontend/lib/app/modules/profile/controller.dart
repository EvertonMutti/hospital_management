import 'package:get/get.dart';
import 'package:hospital_management/app/core/services/auth.dart';

class ProfileController extends GetxController {

  void logout() {
    AuthService.to.logoutUser();
  }

}
