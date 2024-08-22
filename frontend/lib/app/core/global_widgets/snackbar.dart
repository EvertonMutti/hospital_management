import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';

class SnackBarApp {
  static body(String title, String message,
      {IconData? icon, SnackPosition? position, int? duration}) {
    Get.snackbar(
      title,
      message,
      duration: Duration(
        seconds: duration ?? 3,
      ),
      colorText: primaryColor,
      snackPosition: position ?? SnackPosition.BOTTOM,
      backgroundColor: secondaryColor,
      margin: const EdgeInsets.all(16),
      borderRadius: 6.0,
      shouldIconPulse: true,
      maxWidth: 450,
      icon: Icon(icon ?? FontAwesomeIcons.check),
    );
  }
}
