import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/modules/home/beds_list_page/controller.dart';
import 'package:hospital_management/app/modules/home/core/model/bed.dart';

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
        child: Obx(() {
          return NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              final metrics = notification.metrics;
              if (metrics.pixels >= metrics.maxScrollExtent) {
                controller.loadMoreLeitos();
              }
              return true;
            },
            child: ListView.builder(
              itemCount: controller.leitos.length,
              itemBuilder: (context, index) {
                final leito = controller.leitos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      leito.nome!,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Status: ${leito.status.toString().split('.').last}',
                      style: TextStyle(
                        color: leito.status == BedStatus.OCUPADO
                            ? Colors.red
                            : leito.status == BedStatus.MANUTENCAO
                            ? Colors.yellow
                            : Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Icon(
                      leito.status == BedStatus.OCUPADO
                          ? Icons.bed
                          : leito.status == BedStatus.MANUTENCAO
                              ? Icons.build
                              : Icons.bed,
                      color: leito.status == BedStatus.OCUPADO
                          ? Colors.red
                          : leito.status == BedStatus.MANUTENCAO
                              ? Colors.yellow
                              : Colors.green,
                    ),
                    onTap: () => _showStatusDialog(context, leito),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  void _showStatusDialog(BuildContext context, BedModel leito) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 16,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Alterar Status do Leito ${leito.nome}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (leito.status == BedStatus.LIVRE) ...[
                  _buildStatusOption(context, leito, BedStatus.OCUPADO, 'Ocupar Leito'),
                  _buildStatusOption(context, leito, BedStatus.MANUTENCAO, 'Manutenção'),
                ] else if (leito.status == BedStatus.OCUPADO) ...[
                  _buildStatusOption(context, leito, BedStatus.LIVRE, 'Liberar Leito'),
                ] else if (leito.status == BedStatus.MANUTENCAO) ...[
                  _buildStatusOption(context, leito, BedStatus.LIVRE, 'Liberar Leito'),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusOption(BuildContext context, BedModel leito, BedStatus status, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(label),
        onTap: () {
          controller.updateLeitoStatus(leito.id!, status);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
