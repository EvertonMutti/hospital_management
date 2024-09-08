import 'package:get/get.dart';
import 'package:hospital_management/app/modules/home/pages/home/repository.dart';

import '../../core/provider/supplier.dart';
import 'controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SupplierRepository>(HomeProvider());

    Get.lazyPut<HomeController>(
      () => HomeController(
        repository: Get.find<SupplierRepository>(),
      ),
    );
  }
}
