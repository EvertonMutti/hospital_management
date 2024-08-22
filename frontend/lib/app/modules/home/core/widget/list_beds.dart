import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/modules/home/controller.dart';

class ListBedsWidget extends GetView<HomeController> {
  const ListBedsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        shrinkWrap: true, 
        itemCount: controller.leitos.length,
        itemBuilder: (context, index) {
          final leito = controller.leitos[index];
          return ListTile(
            title: Text(leito['nome']!),
            subtitle: Text('Status: ${leito['status']}'),
            trailing: Icon(
              leito['status'] == 'Em uso' ? Icons.bed : Icons.bedroom_baby,
              color: leito['status'] == 'Em uso' ? Colors.red : Colors.green,
            ),
          );
        },
      );
    });
  }
}
