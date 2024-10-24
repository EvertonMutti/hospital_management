
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/core/global_widgets/snackbar.dart';
import 'package:hospital_management/app/modules/home/core/model/bed.dart';
import 'package:hospital_management/app/modules/home/repository.dart';

class BedsController extends GetxController with WidgetsBindingObserver{
  HomeRepository repository;

  BedsController({required this.repository});

  RxList<SectorModel> sector = <SectorModel>[].obs;

  final RxBool _loading = false.obs;
  bool get getLoading => _loading.value;
  set setLoading(bool status) => _loading.value = status;

  @override
  Future<void> onInit() async {
    setLoading = true;
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    setLoading = true;
    super.onReady();
    await _loadBedsBySector();
    setLoading = false;
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      setLoading = true;
      _loadBedsBySector(); 
      setLoading = false;
    }
  }

  Future<void> _loadBedsBySector() async {
    try {
      final response = await repository.consultBedsBySector();

      if (response.status!) {
        sector.value = response.data ?? [];
      }
    } catch (e) {
      SnackBarApp.body('Ops', 'Não foi possível carregar os leitos');
    }
  }

  Future<void> updateBedStatus(BedModel bed, BedStatus newStatus) async {
    setLoading = true;
    try {
      bed.status = newStatus;
      
      if (await repository.updateBed(bed)) {
        SnackBarApp.body('Sucesso', 'Status do leito atualizado com sucesso!', position: SnackPosition.TOP);
        await _loadBedsBySector();
      } else {
        SnackBarApp.body('Erro', 'Não foi possível atualizar o status do leito');
      }
    } catch (e) {
      SnackBarApp.body('Erro', 'Não foi possível atualizar o status do leito');
    }
    setLoading = false;
  }

  Future<void> dischargePatient(int bedId) async {
    setLoading = true;
    try {
      if (await repository.dischargePatient(bedId)) {
        SnackBarApp.body('Sucesso', 'Leito liberado e solicitando limpeza!');
        await _loadBedsBySector();
      } else {
        SnackBarApp.body('Erro', 'Não foi possível trocar o status para "necessita limpeza"');
      }
    } catch (e) {
      SnackBarApp.body('Erro', 'Ocorreu um erro ao trocar de status');
    }
    setLoading = false;
  }

  String getStatusLabel(BedStatus status) {
    switch (status) {
      case BedStatus.OCCUPIED:
        return "Ocupado";
      case BedStatus.FREE:
        return "Livre";
      case BedStatus.MAINTENANCE:
        return "Manutenção";
      case BedStatus.CLEANING:
        return "Em Limpeza";
      case BedStatus.CLEANING_REQUIRED:
        return "Necessário Limpeza";
      default:
        return "Desconhecido";
    }
  }

  Color getStatusColor(BedStatus status) {
    switch (status) {
      case BedStatus.OCCUPIED:
        return Colors.red;
      case BedStatus.MAINTENANCE:
        return Colors.yellow;
      case BedStatus.FREE:
        return Colors.green;
      case BedStatus.CLEANING:
        return Colors.blue;
      case BedStatus.CLEANING_REQUIRED:
        return Colors.orange;
      default:
        throw Exception('Invalid BedStatus');
    }
  }

  IconData getStatusIcon(BedStatus status) {
    switch (status) {
      case BedStatus.OCCUPIED:
        return Icons.bed;
      case BedStatus.MAINTENANCE:
        return Icons.build;
      case BedStatus.FREE:
        return Icons.bed;
      case BedStatus.CLEANING:
        return Icons.cleaning_services;
      case BedStatus.CLEANING_REQUIRED:
        return Icons.warning;
      default:
        throw Exception('Invalid BedStatus');
    }
  }
}
