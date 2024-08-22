import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class RootView extends GetView<RootController> {
  const RootView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(
      builder: (context, delegate, current) {
        return Scaffold(
          body: GetRouterOutlet.pickPages(
            pickPages: (currentNavStack) =>
                currentNavStack.currentTreeBranch.pickAfterRoute('/'),
          ),
        );
      },
    );
  }
}
