import 'package:flutter/material.dart';

import '../utils/colors.dart';

class ProgressIndicatorApp extends StatelessWidget {
  const ProgressIndicatorApp({super.key, this.paddingTop = 50});

  final double paddingTop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(74),
              color: Colors.white,
            ),
            child: const CircularProgressIndicator(
              strokeWidth: 3.5,
              color: secondaryColor,
              backgroundColor: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
