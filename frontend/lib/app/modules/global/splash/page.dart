import 'package:flutter/material.dart';

import '../../../core/global_widgets/progress_indicator.dart';


class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: ProgressIndicatorApp(),
      ),
    );
  }
}
