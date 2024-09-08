import 'package:get/get.dart';
import 'package:hospital_management/app/modules/home/pages/home/controller.dart';
import 'package:hospital_management/app/modules/home/core/provider/supplier.dart';
import 'package:hospital_management/app/modules/home/pages/home/repository.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SupplierRepository>(HomeProvider());
    Get.put<HomeController>(HomeController(repository: Get.find<SupplierRepository>()));
  }
}
