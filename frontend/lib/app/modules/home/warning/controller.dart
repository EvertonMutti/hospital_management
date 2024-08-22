import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarningController extends GetxController
    with GetSingleTickerProviderStateMixin {
  AnimationController? _animationController;
  AnimationController get getAnimation => _animationController!;

  WarningController() {
    _animationController = AnimationController(vsync: this);

    _animationController!.repeat(
      min: 0.3,
      max: 0.6,
      period: const Duration(milliseconds: 1500),
      reverse: true,
    );
  }
}
