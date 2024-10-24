import 'package:get/get.dart';
import 'package:hospital_management/app/modules/home/repository.dart';

import '../core/provider/home.dart';
import 'controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeRepository>(HomeProvider());

    Get.put<HomeController>(HomeController(repository: Get.find<HomeRepository>()));
  }
}
