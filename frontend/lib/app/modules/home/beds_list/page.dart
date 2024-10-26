import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/core/global_widgets/progress_indicator.dart';
import 'package:hospital_management/app/modules/home/core/widget/status_dialog.dart';
import 'package:hospital_management/app/modules/home/beds_list/controller.dart';

class BedsListPage extends GetView<BedsController> {
  const BedsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Leitos'),
        centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back), // Ícone do menu
        //   onPressed: () {
        //     Get.offAllNamed(Routes.home); 
        //   },
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            if (controller.getLoading) {
              return const Center(child: ProgressIndicatorApp());
            }
            else if (controller.sector.isEmpty && controller.getLoading == false) {
              return const Center(
                child: Text(
                  'Sem leitos cadastrados neste hospital',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }
            return ListView.builder(
              itemCount: controller.sector.length,
              itemBuilder: (context, sectorIndex) {
                final sector = controller.sector[sectorIndex];
                return ExpansionTile(
                  title: Text(sector.sectorName ?? 'Setor Desconhecido'),
                  children: sector.beds?.map((bed) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(
                          bed.bedNumber!,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
                        onTap: ()  {
                          showStatusDialog(context, bed, controller);
                        },
                      ),
                    );
                  }).toList() ?? [],
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
