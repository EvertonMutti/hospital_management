import 'package:get/get.dart';
import 'package:hospital_management/app/modules/home/core/provider/supplier.dart';
import 'package:hospital_management/app/modules/home/notification/controller.dart';
import 'package:hospital_management/app/modules/home/repository.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeRepository>(HomeProvider());
    Get.put<NotificationController>(NotificationController(repository: Get.find<HomeRepository>()));
  }
}
