import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/core/routes/routes.dart';
import 'package:hospital_management/app/modules/home/core/model/bed.dart';
import 'package:hospital_management/app/modules/home/beds_list/controller.dart';

Widget buildStatusOption(
    BuildContext context, BedModel bed, BedStatus newStatus, String label, BedsController controller, bool enableButton) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Tooltip(
      message: enableButton ? '' : 'Você não tem permissão para executar essa ação',
      child: ListTile(
        title: Text(label),
        tileColor: enableButton ? null : const Color.fromARGB(255, 235, 232, 232),
        onTap: enableButton
            ? () {
                if (newStatus == BedStatus.OCCUPIED) {
                  Navigator.of(context).pop();
                  Get.toNamed(Routes.patientSelection, arguments: bed);
                }
                else if (bed.status == BedStatus.OCCUPIED && newStatus == BedStatus.CLEANING_REQUIRED) {
                  Navigator.of(context).pop();
                  controller.dischargePatient(bed.id!);
                } else {
                  controller.updateBedStatus(bed, newStatus);
                  Navigator.of(context).pop();
                }
              }
            : null,
      ),
    ),
  );
}
