import 'package:get/get.dart';
import 'package:hospital_management/app/core/global_widgets/snackbar.dart';
import 'package:hospital_management/app/core/routes/routes.dart';
import 'package:hospital_management/app/modules/home/beds_list/controller.dart';
import 'package:hospital_management/app/modules/home/core/model/bed.dart';
import 'package:hospital_management/app/modules/home/core/model/patient_selection.dart';
import 'package:hospital_management/app/modules/home/repository.dart';

class PatientController extends GetxController {
  final HomeRepository repository;

  PatientController({required this.repository});

  RxList<PatientSelection> patients = <PatientSelection>[].obs;
  final RxBool _loading = false.obs;

  final Rx<BedModel> _bed =  BedModel().obs;
  BedModel get getBed => _bed.value;
  set bed(BedModel? value) => _bed.value = value!;
  
  bool get getLoading => _loading.value;
  set setLoading(bool status) => _loading.value = status;

  @override
  Future<void> onReady() async {
    setLoading = true;
    super.onReady();

    if (Get.arguments is BedModel) {
      bed = Get.arguments as BedModel;
    } else {
      bed = BedModel();
      setLoading = false;
      _redirectToListBeds();
    }
    
    await _loadAvailablePatients();
    setLoading = false;
  }

  // @override
  // Future<void> onClose() async {
  //   super.onClose();
  //   Get.find<BedsController>().refreshScreen();
  // }

  Future<void> _loadAvailablePatients() async {
    try {
      final response = await repository.getAvailablePatients();
      if (response.status!) {
        patients.value = response.data ?? [];
      } else{
        SnackBarApp.body('Ops', response.detail ?? 'Não foi possível carregar os pacientes');
      }
    } catch (e) {
      SnackBarApp.body('Erro', 'Não foi possível carregar os pacientes');
    } 
  }

  Future<void> admitPatientToBed(int patientId, int bedId) async {
    try {
      final response = await repository.admitPatient(patientId, bedId);
      if (response.status!) {
        SnackBarApp.body('Sucesso', 'Paciente admitido com sucesso!');
        Get.find<BedsController>().refreshScreen();
      } else {
        SnackBarApp.body('Ops', response.detail ?? 'Não foi possível admitir o paciente');
      }
    } catch (e) {
      SnackBarApp.body('Erro', 'Ocorreu um erro ao admitir o paciente');
    }
  }

  static BedModel _redirectToListBeds() {
    Get.offAllNamed(Routes.home); 
    throw Exception("Leito não especificado.");
  }
}
