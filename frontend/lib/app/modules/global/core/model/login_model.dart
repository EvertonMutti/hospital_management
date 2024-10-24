class LoginModel {
  bool? status;
  String? token;
  String? detail;

  LoginModel({ this.status, this.token, this.detail });

  LoginModel.fromJson(Map<String, dynamic> json) {
    token = json['sub'];
    status = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['sub'] = token;
    return data;
  }
}
