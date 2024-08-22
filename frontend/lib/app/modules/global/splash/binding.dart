import 'package:get/get.dart';
import 'controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashService>(SplashService(), permanent: true);
  }
}
