import 'package:get/get.dart';
import 'package:hospital_management/app/modules/home/core/model/bed.dart';
import 'package:hospital_management/app/modules/home/repository.dart';



class BedsController extends GetxController {

  SupplierRepository repository;

  BedsController({required this.repository});

  final List<BedModel> _allLeitos = List.generate(
    100,
    (index) => BedModel(
      id: index,
      nome: 'Leito ${index + 1}',
      status: index % 2 == 0 ? BedStatus.OCUPADO : BedStatus.LIVRE,
    ),
  );

  final RxList<BedModel> leitos = <BedModel>[].obs;

  int _page = 0;
  final int _pageSize = 20;

  @override
  void onReady() {
    super.onReady();
    _loadLeitos();
  }

  void _loadLeitos() {
    final start = _page * _pageSize;
    final end = (start + _pageSize > _allLeitos.length) ? _allLeitos.length : start + _pageSize;

    leitos.addAll(_allLeitos.sublist(start, end));
    _page++;
  }

  void loadMoreLeitos() {
    _loadLeitos();
  }

  void updateLeitoStatus(int id, BedStatus newStatus) {
    final leitoIndex = leitos.indexWhere((leito) => leito.id == id);
    if (leitoIndex != -1) {
      final leito = leitos[leitoIndex];
      leito.updateStatus(newStatus);
      leitos[leitoIndex] = leito; 
    }
  }
}
