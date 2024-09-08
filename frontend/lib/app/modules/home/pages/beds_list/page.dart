import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/modules/home/core/widget/status_dialog.dart';
import 'package:hospital_management/app/modules/home/pages/beds_list/controller.dart';

class BedsListPage extends GetView<BedsController> {
  const BedsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Leitos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(40.0), 
          ),
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return NotificationListener<ScrollEndNotification>(
              onNotification: (notification) {
                final metrics = notification.metrics;
                if (metrics.pixels >= metrics.maxScrollExtent) {
                  controller.loadMoreBeds();
                }
                return true;
              },
              child: ListView.builder(
                itemCount: controller.beds.length,
                itemBuilder: (context, index) {
                  final bed = controller.beds[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        bed.name!,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Status: ${controller.getStatusLabel(bed.status!)}',
                        style: TextStyle(
                          color: controller.getStatusColor(bed.status!),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Icon(
                        controller.getStatusIcon(bed.status!),
                        color: controller.getStatusColor(bed.status!),
                      ),
                      onTap: () => showStatusDialog(context, bed, controller),
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
