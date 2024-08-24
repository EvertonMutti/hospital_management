import 'package:get/get.dart';
import 'package:hospital_management/app/modules/home/beds_list_page/controller.dart';
import 'package:hospital_management/app/modules/home/core/provider/supplier.dart';
import 'package:hospital_management/app/modules/home/repository.dart';

class BedsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SupplierRepository>(HomeProvider());
    Get.lazyPut<BedsController>(
      () => BedsController(repository: Get.find<SupplierRepository>()),
    );
  }
}
