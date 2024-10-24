
import 'package:get/get.dart';
import 'package:hospital_management/app/core/middleware/auth_middleware.dart';
import 'package:hospital_management/app/modules/home/beds_list/binding.dart';
import 'package:hospital_management/app/modules/home/beds_list/page.dart';
import 'package:hospital_management/app/modules/home/home/binding.dart';
import 'package:hospital_management/app/modules/home/home/page.dart';
import 'package:hospital_management/app/modules/home/patient_selection/binding.dart';
import 'package:hospital_management/app/modules/home/patient_selection/page.dart';
import '../../../../core/routes/routes.dart';

class HomePages {
  static List<GetPage<dynamic>> routes = <GetPage<dynamic>>[
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
      title: "Home page",
      middlewares: [
        AuthMiddleware(),
      ],
    ),
    GetPage(
      name: Routes.bedsList,  
      page: () => const BedsListPage(),
      binding: BedsListBinding(),
      title: "Listagem de leitos",
      middlewares: [
        AuthMiddleware(),
      ],
    ),
    GetPage(
      name: Routes.patientSelection,  
      page: () => PatientSelectionPage(),
      binding: PatientSelectionBinding(),
      title: "Listagem de pacientes",
      middlewares: [
        AuthMiddleware(),
      ],
    ),
  ];
}
