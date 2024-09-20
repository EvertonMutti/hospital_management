import 'package:hospital_management/app/modules/global/core/network/endpoints.dart';
import 'package:hospital_management/app/modules/home/core/model/supplier_list_model.dart';
import 'package:hospital_management/app/modules/home/repository.dart';
import '../network/http_client_supplier.dart';

class HomeProvider implements HomeRepository {
  final _http = HttpClientHome().init;

  @override
  Future<BedList> consultBeds(int query) async {
    try {
      final response = await _http.get(
        '${Endpoints.listBeds}'
        '?energy_consumption=$query'
      );

      return BedList.fromJson(response.data);
    } catch (e) {
      return BedList(status: false, detail: e.toString());
    }
  }
  

}
