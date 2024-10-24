class SignupModel {
  String? name;
  String? password;
  String? email;
  String? phone;
  String? taxNumber;
  String? hospitalUniqueCode;
  String? position;
  String? detail;
  bool? status;

  // Construtor corrigido
  SignupModel({
    this.name,
    this.password,
    this.email,
    this.phone,
    this.taxNumber,
    this.hospitalUniqueCode,
  });

  SignupModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    password = json['password'];
    email = json['email'];
    phone = json['phone'];
    taxNumber = json['tax_number'];
    hospitalUniqueCode = json['hospital_unique_code'];
    position = json['position'];
    status = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['password'] = password;
    data['email'] = email;
    data['phone'] = phone;
    data['tax_number'] = taxNumber;
    data['hospital_unique_code'] = hospitalUniqueCode;
    data['position'] = position;
    return data;
  }
}
