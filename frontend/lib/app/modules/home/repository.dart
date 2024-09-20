
import 'package:hospital_management/app/modules/home/core/model/supplier_list_model.dart';

abstract class HomeRepository {
  Future<BedList> consultBeds(int query);
}
