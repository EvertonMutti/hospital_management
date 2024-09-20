import 'package:flutter/material.dart';
import 'package:hospital_management/app/modules/home/core/model/bed.dart';
import 'package:hospital_management/app/modules/home/beds_list/controller.dart';

Widget buildStatusOption(
    BuildContext context, BedModel bed, BedStatus status, String label, BedsController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: ListTile(
      title: Text(label),
      onTap: () {
        controller.updateBedStatus(bed.id!, status);
        Navigator.of(context).pop();
      },
    ),
  );
}
