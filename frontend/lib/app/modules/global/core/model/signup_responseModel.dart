class SignupResponseModel {
  bool status;
  int? id;
  String? name;
  String? email;
  String? detail;

  SignupResponseModel({
    this.status = false,
    this.id,
    this.name,
    this.email,
    this.detail,
  });

  SignupResponseModel.fromJson(Map<String, dynamic> json)
      : status = json.containsKey('status') ? json['status'] : true,
        id = json['id'],
        name = json['name'],
        email = json['email'],
        detail = json['detail'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['detail'] = detail;
    return data;
  }
}
