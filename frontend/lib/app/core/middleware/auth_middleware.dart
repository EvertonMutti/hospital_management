import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/core/services/auth.dart';

import '../routes/routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route){
    if (!AuthService.to.getUser.isLoggedIn!) {
      return const RouteSettings(name: Routes.signIn);
    }
    return null;
  }

  @override
  // ignore: unnecessary_overrides
  GetPage? onPageCalled(GetPage? page) {
    return super.onPageCalled(page);
  }
}

class NotAuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route){
    if (AuthService.to.getUser.isLoggedIn!) {
      return const RouteSettings(name: Routes.home);
    }
    return null;
  }
}


class ForceNavigateToRouteMiddleware extends GetMiddleware {
  final String from;
  final String to;

  ForceNavigateToRouteMiddleware({
    required this.from,
    required this.to,
  });

  @override
  RouteSettings? redirect(String? route){
    if (route == from) {
      return RouteSettings(name: to);
    }
    return const RouteSettings(name: Routes.notFound);
  }
}