import 'package:get/get.dart';
import 'package:hospital_management/app/core/middleware/auth_middleware.dart';
import 'package:hospital_management/app/modules/global/404/binding.dart';
import 'package:hospital_management/app/modules/global/404/page.dart';
import 'package:hospital_management/app/modules/global/root/binding.dart';
import 'package:hospital_management/app/modules/global/root/page.dart';
import 'package:hospital_management/app/modules/home/core/routes/pages.dart';
import 'package:hospital_management/app/modules/profile/core/routes/pages.dart';
import '../../../modules/global/sign_in/binding.dart';
import '../../../modules/global/sign_in/page.dart';
import '../routes.dart';



class Pages {
  static final List<GetPage<dynamic>> routes = <GetPage<dynamic>>[
    GetPage(
      name: '/',
      page: () => const RootView(),
      bindings: [RootBinding()],
      participatesInRootNavigator: true,
      preventDuplicates: true,
      title: "Root",
      middlewares: [
        AuthMiddleware(),
        ForceNavigateToRouteMiddleware(from: '/', to: '/home'),
      ],
    ),
    GetPage(
      name: Routes.signIn,
      page: () => const SignInPage(),
      binding: SignInBinding(),
      title: "Login",
      middlewares: [
        NotAuthMiddleware(),
      ],
    ),
    GetPage(
        name: '/404',
        page: () => const NotFoundPage(),
        binding: NotFoundBinding(),
        title: "Not Found",
      ),
    ...HomePages.routes,
    ...ProfilePages.routes
  ];
}
