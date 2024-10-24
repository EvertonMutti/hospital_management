class PatientSelection {
  int? id;
  String? name;

  PatientSelection({this.id, this.name});

  PatientSelection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}


class PatientSelectionList {
  List<PatientSelection>? data;
  bool? status;
  String? detail;

  PatientSelectionList({this.data, this.status, this.detail});

  PatientSelectionList.fromJson(List<dynamic> json) {
    data = <PatientSelection>[];
    for (var item in json) {
      data!.add(PatientSelection.fromJson(item));
    }
    status = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = data;
    return data;
  }
}