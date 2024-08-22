import 'package:get/get.dart';
import 'controller.dart';

class NotFoundBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotFoundController>(() => NotFoundController());
  }
}
