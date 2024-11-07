import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hospital_management/app/core/config/config.dart';
import 'package:hospital_management/app/core/global_widgets/enviroment_info.dart';
import 'package:hospital_management/app/core/routes/routes.dart';
import 'package:hospital_management/app/core/services/auth.dart';
import 'package:hospital_management/app/modules/global/404/page.dart';
import 'package:hospital_management/app/modules/global/splash/page.dart';

import 'core/routes/pages/pages.dart';
import 'core/theme/theme.dart';
import 'modules/global/splash/controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const locale = Locale('pt', 'BR');

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.home,
      title: 'Gerenciador hospitalar',
      theme: themeData,
      initialBinding: BindingsBuilder(
        () {
          Get.put(AuthService());
          Get.put(SplashService());
        },
      ),
      builder: (context, child) {
        return Stack(children: [
          FutureBuilder<void>(
            key: const Key("Gerenciador hospitalar"),
            future: Get.find<SplashService>().init(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return child ?? const SizedBox.shrink();
              }
              return const SplashPage();
            },
          ),
          const EnvironmentInfo(),
        ]);
      },
      getPages: Pages.routes,
      unknownRoute: GetPage(
        name: Routes.notFound,
        page: () => const NotFoundPage(),
      ),
      themeMode: ThemeMode.system,
      locale: locale,
      fallbackLocale: locale,
      supportedLocales: const [locale],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      defaultTransition: Transition.fade,
    );
  }
}
