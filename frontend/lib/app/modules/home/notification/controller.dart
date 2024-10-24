import 'package:get/get.dart';
import 'package:hospital_management/app/modules/global/core/model/notification.dart';
import 'package:hospital_management/app/modules/home/repository.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart'; 

class NotificationController extends GetxController {
  HomeRepository repository;

  NotificationController({required this.repository});

  @override
  Future<void> onReady() async {
    super.onReady();
    await fetchDataNotification();
  }

  final RxBool _loading = false.obs;
  bool get getLoading => _loading.value;
  set setLoading(bool status) => _loading.value = status;

  //Notifications
  final RxInt notificationCount = 0.obs;
  var notifications = <Notification>[].obs;

  void addNotification(Notification notification) {
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
    setLoading = true;
    await Future.delayed(const Duration(seconds: 1)); 

    var fetchedNotifications = [
      Notification(
        id:1,
        title: 'Atualização de Status',
        body: 'O leito 101 agora está livre.',
        date: DateTime.now().subtract(const Duration(days: 0)),
      ),
      Notification(
        id:2,
        title: 'Novo Paciente',
        body: 'Um novo paciente foi admitido no leito 102.',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Notification(
        id:3,
        title: 'Manutenção Programada',
        body: 'Manutenção programada para o leito 103.',
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Notification(
        id:4,
        title: 'Alta Médica',
        body: 'O paciente do leito 104 teve alta.',
        date: DateTime.now().subtract(const Duration(days: 7)), 
      ),
      Notification(
        id:5,
        title: 'Aviso de Segurança',
        body: 'Verificação de rotina de segurança no hospital.',
        date: DateTime.now().subtract(const Duration(days: 10)), 
      ),
    ];

    notifications.assignAll(fetchedNotifications);
    notificationCount.value = notifications.length;
    setLoading = false;
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
}
