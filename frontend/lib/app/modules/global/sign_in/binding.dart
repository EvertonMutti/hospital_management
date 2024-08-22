import 'package:get/get.dart';

import '../core/provider/sign_in.dart';
import 'controller.dart';
import 'repository.dart';

class SignInBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInRepository>(() => SignInProvider(), fenix: true);
    Get.lazyPut<SignInController>(
      () => SignInController(signInRepository: Get.find()),
      fenix: true,
    );
  }
}
