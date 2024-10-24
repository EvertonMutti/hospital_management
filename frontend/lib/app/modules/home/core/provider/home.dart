import 'package:hospital_management/app/core/services/auth.dart';
import 'package:hospital_management/app/modules/global/core/network/endpoints.dart';
import 'package:hospital_management/app/modules/home/core/model/admission.dart';
import 'package:hospital_management/app/modules/home/core/model/bed.dart';
import 'package:hospital_management/app/modules/home/core/model/patient_selection.dart';
import 'package:hospital_management/app/modules/home/repository.dart';
import '../network/http_client_supplier.dart';

class HomeProvider implements HomeRepository {
  final _http = HttpClientHome().init;

  @override
  Future<ListSectorModel> consultBedsBySector() async {
    try {
      final response = await _http.get(
        '${Endpoints.listBeds}/${AuthService.to.getUser.hospital!.taxNumber}',
      );
      return ListSectorModel.fromJson(response.data);
    } catch (e) {
      return ListSectorModel(status: false, detail: e.toString());
    }
  }

  @override
  Future<bool> updateBed(BedModel bed) async {
    try {
      await _http.put(
        '${Endpoints.listBeds}/${AuthService.to.getUser.hospital!.taxNumber}/${bed.id}',
        data: {
          'status': bed.status.toString().split('.').last,
          'sector_id': bed.sectorId,
          'bed_number': bed.bedNumber,
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }


  @override
  Future<CountBed> getCountBeds() async {
    try {
      final response = await _http.get(
        '${Endpoints.countBeds}/${AuthService.to.getUser.hospital!.taxNumber}',
      );
      return CountBed.fromJson(response.data);
    } catch (e) {
      return CountBed(status: false);
    }
  }

  @override
  Future<PatientSelectionList> getAvailablePatients() async {
    try {
      final response = await _http.get(
        Endpoints.availablePatients(AuthService.to.getUser.hospital!.taxNumber!),
      );
      return PatientSelectionList.fromJson(response.data);
    } catch (e) {
      return PatientSelectionList(status: false);
    }
  }

  @override
  Future<Admission> admitPatient(int patientId, int bedId) async {
    try {
      final response = await _http.post(
        '${Endpoints.admission}/${AuthService.to.getUser.hospital!.taxNumber}/$bedId/$patientId',
      );
      return Admission.fromJson(response.data);
    } catch (e) {
      return Admission(status: false);
    }
  }


  @override
  Future<bool> dischargePatient(int bedId) async {
    try {
      await _http.put(
        '${Endpoints.discharge}/${AuthService.to.getUser.hospital!.taxNumber}/$bedId',
      );
      return true;
    } catch (e) {
      return false;
    }
  }
  

}