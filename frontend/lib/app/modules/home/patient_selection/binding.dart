import 'package:get/get.dart';
import 'package:hospital_management/app/modules/home/patient_selection/controller.dart';
import 'package:hospital_management/app/modules/home/repository.dart';

import '../core/provider/home.dart';

class PatientSelectionBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeRepository>(HomeProvider());
    Get.put<PatientController>(PatientController(repository: Get.find<HomeRepository>()));
  }
}
