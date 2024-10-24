import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/core/global_widgets/progress_indicator.dart';
import 'package:hospital_management/app/modules/home/core/model/patient_selection.dart';
import 'package:hospital_management/app/modules/home/patient_selection/controller.dart';

class PatientSelectionPage extends GetView<PatientController> {
  const PatientSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.getLoading && controller.getBed.id == null) {
        return Container(
          color: Colors.black54,
          child: const Center(
            child: ProgressIndicatorApp(),
          ),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(
                  'Selecionar Paciente para Leito ${controller.getBed.bedNumber}'),
            ),
          ),
          body: Obx(() {
            if (controller.patients.isEmpty) {
              return const Center(child: Text('Nenhum paciente disponível.'));
            } else {
              return ListView.builder(
                itemCount: controller.patients.length,
                itemBuilder: (context, index) {
                  final patient = controller.patients[index];
                  return ListTile(
                    title: Text(patient.name!),
                    onTap: () {
                      _showConfirmationDialog(context, patient);
                    },
                  );
                },
              );
            }
          }),
        );
      }
    });
  }

  void _showConfirmationDialog(BuildContext context, PatientSelection patient) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Confirmar Ação',
            style: TextStyle(color: Color.fromARGB(255, 189, 101, 94)),
          ),
          content: RichText(
            text: TextSpan(
              text: 'Você realmente deseja ocupar o leito com o paciente ',
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: '${patient.name}?',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.black,
                    decorationThickness: 2,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  Row (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white),
                        onPressed: () {
                          controller.admitPatientToBed(
                              patient.id!, controller.getBed.id!);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Confirmar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
