import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:async/async.dart';
import 'package:get/get.dart';

class SplashService extends GetxService {
  final memo = AsyncMemoizer<void>();

  Future<void> init() {
    return memo.runOnce(_initFunction);
  }

  Future<void> _initFunction() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
