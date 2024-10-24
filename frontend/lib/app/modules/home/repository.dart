
import 'package:hospital_management/app/modules/home/core/model/admission.dart';
import 'package:hospital_management/app/modules/home/core/model/bed.dart';
import 'package:hospital_management/app/modules/home/core/model/patient_selection.dart';

abstract class HomeRepository {
  Future<ListSectorModel> consultBedsBySector();
  Future<bool> updateBed(BedModel bed);
  Future<CountBed> getCountBeds();
  Future<PatientSelectionList> getAvailablePatients();
  Future<Admission> admitPatient(int patientId, int bedId);
  Future<bool> dischargePatient(int bedId);
}
