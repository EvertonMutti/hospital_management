class Hospital {
  String? name;
  String? taxNumber;
  String? address;
  int? id;
  String? uniqueCode;

  Hospital({this.name, this.taxNumber, this.address, this.id, this.uniqueCode});

  Hospital.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    taxNumber = json['tax_number'];
    address = json['address'];
    id = json['id'];
    uniqueCode = json['unique_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['tax_number'] = taxNumber;
    data['address'] = address;
    data['id'] = id;
    data['unique_code'] = uniqueCode;
    return data;
  }
}

class HospitalList {
  bool? status;
  List<Hospital>? data;
  String? detail;

  HospitalList({this.status, this.data, this.detail});

  HospitalList.fromJson(List<dynamic> json) {
    data = <Hospital>[];
    for (var v in json) {
        data!.add(Hospital.fromJson(v));
      }
    status = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = data;
    return data;
  }
}