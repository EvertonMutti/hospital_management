import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/core/routes/routes.dart';
import 'package:hospital_management/app/modules/global/404/controller.dart';

class NotFoundPage extends GetView<NotFoundController> {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              '404',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Página não encontrada',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.offAllNamed(Routes.home);
              },
              child: const Text('Voltar para a Página Inicial'),
            ),
          ],
        ),
      ),
    );
  }
}
