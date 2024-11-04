import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/core/global_widgets/snackbar.dart';
import 'package:hospital_management/app/modules/global/core/model/notification.dart' as app_notification;
import 'package:hospital_management/app/modules/home/core/model/bed.dart';
import 'package:hospital_management/app/modules/home/repository.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart'; 

class HomeController extends GetxController with WidgetsBindingObserver {
  HomeRepository repository;

  HomeController({required this.repository});

  Rx<CountBed> countBed = CountBed().obs;
  set setCountBed(CountBed value) => countBed.value = value;

  final RxBool loading = false.obs;
  bool get getLoading => loading.value;
  set setLoading(bool status) => loading.value = status;

  int get totalBeds =>
      (countBed.value.free ?? 0) +
      (countBed.value.occupied ?? 0) +
      (countBed.value.maintenance ?? 0) +
      (countBed.value.cleaning ?? 0) +
      (countBed.value.cleaningRequired ?? 0);

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      setLoading = true;
      _fetchData(); 
      setLoading = false;
    }
  }

  @override
  Future<void> onInit() async {
    setLoading = true;
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    setLoading = true;
    super.onReady();
    await fetchDataNotification();
    await _fetchData();
    setLoading = false;
  }

  Future<void> _fetchData() async {
    try {
      final response = await repository.getCountBeds();

      if (response.status!) {
        setCountBed = response;
      }
    } catch (e) {
      SnackBarApp.body('Ops', 'Não foi possível carregar os leitos');
    }
  }

  double calculatePercentage(double value) {
    if (totalBeds == 0) return 0;
    return (value / totalBeds) * 100;
  }


  final RxInt notificationCount = 0.obs;
  var notifications = <app_notification.Notification>[].obs;

  void addNotification(app_notification.Notification notification) {
    notifications.add(notification);
    notificationCount.value = notifications.length;
  }

  void clearNotifications() {
    notifications.clear();
    notificationCount.value = 0;
  }

  void removeNotification(int index) {
    notifications.removeAt(index);
    notificationCount.value = notifications.length;
  }

  Future<void> fetchDataNotification() async {
    await Future.delayed(const Duration(seconds: 1)); 

    var fetchedNotifications = [
      app_notification.Notification(
        id:1,
        title: 'Atualização de Status',
        body: 'O leito 101 agora está livre.',
        date: DateTime.now().subtract(const Duration(days: 0)), // Hoje
      ),
      app_notification.Notification(
        id:2,
        title: 'Novo Paciente',
        body: 'Um novo paciente foi admitido no leito 102.',
        date: DateTime.now().subtract(const Duration(days: 1)), // Ontem
      ),
      app_notification.Notification(
        id:3,
        title: 'Manutenção Programada',
        body: 'Manutenção programada para o leito 103.',
        date: DateTime.now().subtract(const Duration(days: 3)), // 3 dias atrás
      ),
      app_notification.Notification(
        id:4,
        title: 'Alta Médica',
        body: 'O paciente do leito 104 teve alta.',
        date: DateTime.now().subtract(const Duration(days: 7)), // 7 dias atrás
      ),
      app_notification.Notification(
        id:5,
        title: 'Aviso de Segurança',
        body: 'Verificação de rotina de segurança no hospital.',
        date: DateTime.now().subtract(const Duration(days: 10)), // 10 dias atrás
      ),
    ];

    notifications.assignAll(fetchedNotifications);
    notificationCount.value = notifications.length;
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference < 1) {
      return 'Hoje | ${DateFormat('HH:mm').format(date)}';
    } else if (difference == 1) {
      return 'Ontem | ${DateFormat('HH:mm').format(date)}';
    } else if (difference <= 7) {
      return '$difference dias atrás | ${DateFormat('HH:mm').format(date)}';
    } else {
      return '${DateFormat('MMM d, yyyy', 'pt_BR').format(date)} | ${DateFormat('HH:mm').format(date)}';
    }
  }
  final RxBool isChartExpanded = false.obs;

  void toggleChartExpand() {
    isChartExpanded.value = !isChartExpanded.value;
  }

  void handlePieTouch(int tappedIndex) {
    if (selectedSection.value == tappedIndex) {
      selectedSection.value = -1;
    } else {
      selectedSection.value = tappedIndex;
    }
  }

  final RxInt selectedSection = (-1).obs;

  double get chartSize {
    double screenHeight = Get.context!.height;
    return isChartExpanded.value ? screenHeight * 0.36 : screenHeight * 0.33;
  }

  double get centerSpaceRadius => isChartExpanded.value ? 40 : 30;
}
