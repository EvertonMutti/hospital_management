import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/modules/home/core/model/bed.dart';
import 'package:hospital_management/app/modules/home/pages/home/repository.dart';



class BedsController extends GetxController {

  SupplierRepository repository;

  BedsController({required this.repository});

  final List<BedModel> _allBeds = List.generate(
    100,
    (index) => BedModel(
      id: index,
      name: 'Leito ${index + 1}',
      status: index % 2 == 0 ? BedStatus.OCUPADO : BedStatus.LIVRE,
    ),
  );

  final RxList<BedModel> beds = <BedModel>[].obs;

  int _page = 0;
  final int _pageSize = 20;

  @override
  void onReady() {
    super.onReady();
    _loadBeds();
  }

  void _loadBeds() {
    final start = _page * _pageSize;
    final end = (start + _pageSize > _allBeds.length) ? _allBeds.length : start + _pageSize;

    beds.addAll(_allBeds.sublist(start, end));
    _page++;
  }

  void loadMoreBeds() {
    _loadBeds();
  }

  void updateBedStatus(int id, BedStatus newStatus) {
    final bedIndex = beds.indexWhere((leito) => leito.id == id);
    if (bedIndex != -1) {
      final bed = beds[bedIndex];
      bed.updateStatus(newStatus);
      beds[bedIndex] = bed; 
    }
  }

  String getStatusLabel(BedStatus status) {
    return status.toString().split('.').last;
  }

  Color getStatusColor(BedStatus status) {
    switch (status) {
      case BedStatus.OCUPADO:
        return Colors.red;
      case BedStatus.MANUTENCAO:
        return Colors.yellow;
      case BedStatus.LIVRE:
        return Colors.green;
      case BedStatus.EM_LIMPEZA:
        return Colors.blue; 
      case BedStatus.NECESSARIO_LIMPEZA:
        return Colors.orange; 
      default:
        throw Exception('Invalid BedStatus');
    }
  }

  IconData getStatusIcon(BedStatus status) {
    switch (status) {
      case BedStatus.OCUPADO:
        return Icons.bed;
      case BedStatus.MANUTENCAO:
        return Icons.build;
      case BedStatus.LIVRE:
        return Icons.bed;
      case BedStatus.EM_LIMPEZA:
        return Icons.cleaning_services;
      case BedStatus.NECESSARIO_LIMPEZA:
        return Icons.warning; 
      default:
      throw Exception('Invalid BedStatus'); 
    }
  }
}
