import 'package:get/get.dart';
import 'package:hospital_management/app/core/model/notification.dart';
import 'package:hospital_management/app/modules/home/repository.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart'; 

class HomeController extends GetxController {
  SupplierRepository repository;

  HomeController({required this.repository});

  @override
  Future<void> onReady() async {
    super.onReady();
    await fetchDataNotification();
  }

  //Beds
  final RxInt leitosEmUso = 50.obs;
  final RxInt leitosLivres = 25.obs;
  final RxInt leitosManutencao = 25.obs;
  

  final leitos = [
    {'nome': 'Leito 101', 'status': 'Em uso'},
    {'nome': 'Leito 102', 'status': 'Livre'},
    {'nome': 'Leito 103', 'status': 'Em uso'},
    {'nome': 'Leito 104', 'status': 'Livre'},
  ].obs;

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
    await Future.delayed(Duration(seconds: 1)); // Simulação de atraso

    // Dados de exemplo, substitua com a chamada real à API ou lógica de busca
    var fetchedNotifications = [
      Notification(
        id:1,
        title: 'Atualização de Status',
        body: 'O leito 101 agora está livre.',
        date: DateTime.now().subtract(Duration(days: 0)), // Hoje
      ),
      Notification(
        id:2,
        title: 'Novo Paciente',
        body: 'Um novo paciente foi admitido no leito 102.',
        date: DateTime.now().subtract(Duration(days: 1)), // Ontem
      ),
      Notification(
        id:3,
        title: 'Manutenção Programada',
        body: 'Manutenção programada para o leito 103.',
        date: DateTime.now().subtract(Duration(days: 3)), // 3 dias atrás
      ),
      Notification(
        id:4,
        title: 'Alta Médica',
        body: 'O paciente do leito 104 teve alta.',
        date: DateTime.now().subtract(Duration(days: 7)), // 7 dias atrás
      ),
      Notification(
        id:5,
        title: 'Aviso de Segurança',
        body: 'Verificação de rotina de segurança no hospital.',
        date: DateTime.now().subtract(Duration(days: 10)), // 10 dias atrás
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
  //Notifications

  // Pie Chart
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

  double get chartSize => isChartExpanded.value ? 220 : 200;

  double get pieSectionRadius => isChartExpanded.value ? 60 : 40;

  double get centerSpaceRadius => isChartExpanded.value ? 50 : 30;
  // Pie Chart
}
