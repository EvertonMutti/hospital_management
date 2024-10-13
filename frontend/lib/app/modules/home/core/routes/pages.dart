
import 'package:get/get.dart';
import 'package:hospital_management/app/core/middleware/auth_middleware.dart';
import 'package:hospital_management/app/modules/home/home/binding.dart';
import 'package:hospital_management/app/modules/home/home/page.dart';
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
  ];
}
