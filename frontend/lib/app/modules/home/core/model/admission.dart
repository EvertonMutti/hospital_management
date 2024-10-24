class Admission {
  int? id;
  int? patientId;
  int? bedId;
  String? admissionDate;
  String? dischargeDate;
  bool? status;
  String? detail;

  Admission(
      {this.id,
      this.patientId,
      this.bedId,
      this.admissionDate,
      this.dischargeDate,
      this.status,
      this.detail});

  Admission.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    bedId = json['bed_id'];
    admissionDate = json['admission_date'];
    dischargeDate = json['discharge_date'];
    status = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['patient_id'] = patientId;
    data['bed_id'] = bedId;
    data['admission_date'] = admissionDate;
    data['discharge_date'] = dischargeDate;
    return data;
  }
}
