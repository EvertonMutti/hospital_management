class AuthUserModel {
  int? userId;
  String? username;
  String? email;
  String? token;
  bool? isLoggedIn;
  bool? admin;

  AuthUserModel({
    this.userId,
    this.username,
    this.email,
    this.token,
    this.isLoggedIn = false,
  });

  AuthUserModel.fromJson(Map<String, dynamic> json) {
    userId = json['id_user'];
    username = json['username'];
    email = json['email'];
    token = json['token'];
    isLoggedIn = json['is_logged_in'] ?? false;
    admin = json['admin'] ?? false;
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['username'] = username;
    data['email'] = email;
    data['token'] = token;
    data['is_logged_in'] = isLoggedIn;
    data['admin'] = admin;
    return data;
  }
}
