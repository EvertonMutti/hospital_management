
import 'package:get/get.dart';
import 'package:hospital_management/app/core/middleware/auth_middleware.dart';
import 'package:hospital_management/app/modules/profile/binding.dart';
import 'package:hospital_management/app/modules/profile/page.dart';
import '../../../../core/routes/routes.dart';

class ProfilePages {
  static List<GetPage<dynamic>> routes = <GetPage<dynamic>>[
    GetPage(
      name: Routes.profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
      title: "Profile page",
      transition: Transition.rightToLeft,
      middlewares: [
        AuthMiddleware(),
      ],
    ),
  ];
}
