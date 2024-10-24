import 'package:flutter/material.dart';
import 'package:hospital_management/app/core/services/auth.dart';
import 'package:hospital_management/app/modules/global/core/Enum/scopes.dart';
import 'package:hospital_management/app/modules/home/core/model/bed.dart';
import 'package:hospital_management/app/modules/home/beds_list/controller.dart';
import 'status_option.dart';

void showStatusDialog(
    BuildContext context, BedModel bed, BedsController controller) {
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
                'Alterar Status do Leito ${bed.bedNumber}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (bed.status == BedStatus.FREE) ...[
                buildStatusOption(
                    context,
                    bed,
                    BedStatus.CLEANING_REQUIRED,
                    'Necessita de Limpeza',
                    controller,
                    AuthService.to.getUser.position == PositionEnum.CLEANER ||
                    AuthService.to.getUser.position == PositionEnum.NURSE ||
                        AuthService.to.getUser.admin!),
                buildStatusOption(
                    context,
                    bed,
                    BedStatus.OCCUPIED,
                    'Ocupar Leito',
                    controller,
                    AuthService.to.getUser.position == PositionEnum.NURSE ||
                        AuthService.to.getUser.admin!),
              ] else if (bed.status == BedStatus.CLEANING_REQUIRED) ...[
                buildStatusOption(
                    context,
                    bed,
                    BedStatus.CLEANING,
                    'Em Limpeza',
                    controller,
                    AuthService.to.getUser.position == PositionEnum.CLEANER ||
                        AuthService.to.getUser.admin!),
              ] else if (bed.status == BedStatus.CLEANING) ...[
                buildStatusOption(
                    context,
                    bed,
                    BedStatus.FREE,
                    'Liberar Leito',
                    controller,
                    AuthService.to.getUser.position == PositionEnum.CLEANER ||
                        AuthService.to.getUser.admin!),
              ]
              else if (bed.status == BedStatus.MAINTENANCE) ...[
                buildStatusOption(
                    context,
                    bed,
                    BedStatus.FREE,
                    'Liberar Leito',
                    controller,
                    AuthService.to.getUser.position == PositionEnum.CLEANER ||
                        AuthService.to.getUser.admin!),
              ]
              else if (bed.status == BedStatus.OCCUPIED) ...[
                buildStatusOption(
                    context,
                    bed,
                    BedStatus.CLEANING_REQUIRED,
                    'Liberar Leito',
                    controller,
                    AuthService.to.getUser.position == PositionEnum.NURSE ||
                        AuthService.to.getUser.admin!),
              ],

              if (bed.status != BedStatus.OCCUPIED && bed.status != BedStatus.MAINTENANCE &&
                  AuthService.to.getUser.admin!) ...[
                buildStatusOption(context, bed, BedStatus.MAINTENANCE,
                    'Enviar para Manutenção', controller, true),
              ],
            ],
          ),
        ),
      );
    },
  );
}
