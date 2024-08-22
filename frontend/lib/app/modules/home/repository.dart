
import 'package:hospital_management/app/modules/home/core/model/supplier_list_model.dart';

abstract class SupplierRepository {
  Future<BedList> consultSupplier(int query);
  
}
