import 'package:get/get.dart';
import 'package:hospital_management/app/modules/home/pages/beds_list/controller.dart';
import 'package:hospital_management/app/modules/home/core/provider/supplier.dart';
import 'package:hospital_management/app/modules/home/pages/home/repository.dart';

class BedsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SupplierRepository>(HomeProvider());
    Get.lazyPut<BedsController>(
      () => BedsController(repository: Get.find<SupplierRepository>()),
    );
  }
}
