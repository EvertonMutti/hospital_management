
import 'package:hospital_management/app/modules/home/core/model/bed.dart';

abstract class HomeRepository {
  Future<ListSectorModel> consultBedsBySector();
  Future<bool> updateBed(BedModel bed);
  Future<CountBed> getCountBeds();
}
