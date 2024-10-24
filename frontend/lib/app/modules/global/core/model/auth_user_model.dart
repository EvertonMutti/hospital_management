import 'package:hospital_management/app/modules/global/core/Enum/scopes.dart';
import 'package:hospital_management/app/modules/global/core/model/hospital_model.dart';

class AuthUserModel {
  int? userId;
  String? username;
  String? email;
  String? token;
  bool? isLoggedIn;
  bool? admin;
  String? phone; 
  String? taxNumber;  
  PositionEnum? position;  
  PermissionEnum? permission;
  Hospital? hospital;

  AuthUserModel({
    this.userId,
    this.username,
    this.email,
    this.token,
    this.isLoggedIn = false,
    this.phone, 
    this.taxNumber,
    this.position, 
    this.permission,
    this.hospital,
  });

  AuthUserModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    email = json['email'];
    token = json['token'];
    isLoggedIn = json['is_logged_in'] ?? false;
    admin = json['admin'] ?? false;
    phone = json['phone']; 
    taxNumber = json['tax_number'];
    position = PositionEnum.values.firstWhere((e) => e.toString() == 'PositionEnum.${json['position']}');  
    permission = PermissionEnum.values.firstWhere((e) => e.toString() == 'PermissionEnum.${json['permission']}');
    hospital = Hospital.fromJson(json['hospital']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['username'] = username;
    data['email'] = email;
    data['token'] = token;
    data['is_logged_in'] = isLoggedIn;
    data['admin'] = admin;
    data['phone'] = phone;
    data['tax_number'] = taxNumber;
    data['position'] = position?.toString().split('.').last;
    data['permission'] = permission?.toString().split('.').last;
    data['hospital'] = hospital?.toJson();
    return data;
  }
}
