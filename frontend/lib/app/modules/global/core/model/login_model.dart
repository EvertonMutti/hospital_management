class LoginModel {
  bool? status;
  String? token;

  LoginModel({ this.status, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = true;
    token = json['sub'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['sub'] = token;
    return data;
  }
}
