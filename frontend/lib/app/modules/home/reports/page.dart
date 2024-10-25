import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/core/global_widgets/progress_indicator.dart';
import 'controller.dart';

class ReportsPage extends GetView<ReportsController> {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de Cadastros'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              controller.savePdf();
            },
          ),
        ],
      ),
      body: Obx(() {
        return Stack(
          children: [
            if (!controller.getLoading && controller.signups.isEmpty)
              const Center(child: Text('Nenhum cadastro encontrado'))
            else if (!controller.getLoading)
              ListView.builder(
                itemCount: controller.signups.length,
                itemBuilder: (context, index) {
                  final signup = controller.signups[index];
                  return ListTile(
                    title: Text(signup.name!),
                    subtitle: Text(signup.email!),
                    leading: const Icon(Icons.person),
                  );
                },
              ),
            if (controller.getLoading)
              const Center(child: ProgressIndicatorApp()),
          ],
        );
      }),
    );
  }
}
