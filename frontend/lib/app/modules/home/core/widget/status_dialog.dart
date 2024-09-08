import 'package:flutter/material.dart';
import 'package:hospital_management/app/modules/home/core/model/bed.dart';
import 'package:hospital_management/app/modules/home/pages/beds_list/controller.dart';
import 'status_option.dart';

void showStatusDialog(BuildContext context, BedModel bed, BedsController controller) {
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
                'Alterar Status do Leito ${bed.name}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (bed.status == BedStatus.LIVRE) ...[
                buildStatusOption(context, bed, BedStatus.OCUPADO, 'Ocupar Leito', controller),
                buildStatusOption(context, bed, BedStatus.MANUTENCAO, 'Manutenção', controller),
              ] else if (bed.status == BedStatus.OCUPADO) ...[
                buildStatusOption(context, bed, BedStatus.LIVRE, 'Liberar Leito', controller),
              ] else if (bed.status == BedStatus.MANUTENCAO) ...[
                buildStatusOption(context, bed, BedStatus.LIVRE, 'Liberar Leito', controller),
              ],
            ],
          ),
        ),
      );
    },
  );
}
