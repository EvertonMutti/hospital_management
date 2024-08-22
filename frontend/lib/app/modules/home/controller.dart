import 'package:get/get.dart';
import 'package:hospital_management/app/modules/home/repository.dart';

class HomeController extends GetxController {
  SupplierRepository repository;

  HomeController({required this.repository});

  final RxInt notificationCount = 5.obs;

  final RxInt leitosEmUso = 75.obs;
  final RxInt leitosLivres = 25.obs;

  final leitos = [
    {'nome': 'Leito 101', 'status': 'Em uso'},
    {'nome': 'Leito 102', 'status': 'Livre'},
    {'nome': 'Leito 103', 'status': 'Em uso'},
    {'nome': 'Leito 104', 'status': 'Livre'},
  ].obs;

  void increaseNotificationCount() {
    notificationCount.value++;
  }

  void clearNotifications() {
    notificationCount.value = 0;
  }


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
