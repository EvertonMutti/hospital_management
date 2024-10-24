import 'package:get/get.dart';
import 'package:hospital_management/app/modules/home/beds_list/controller.dart';
import 'package:hospital_management/app/modules/home/core/provider/home.dart';
import 'package:hospital_management/app/modules/home/repository.dart';

class BedsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeRepository>(HomeProvider());
    Get.lazyPut<BedsController>(
      () => BedsController(repository: Get.find<HomeRepository>()),
    );
  }
}
