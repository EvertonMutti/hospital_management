import 'package:get/get.dart';
import 'controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootController>(() => RootController());
  }
}
