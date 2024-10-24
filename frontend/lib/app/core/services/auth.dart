import 'dart:async';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:async/async.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/modules/global/core/Enum/scopes.dart';
import 'package:hospital_management/app/modules/global/core/model/hospital_model.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../modules/global/core/model/auth_user_model.dart';
import '../routes/routes.dart';
import 'storage.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final memo = AsyncMemoizer<void>();

  final Rx<AuthUserModel> _authUser = AuthUserModel().obs;
  AuthUserModel get getUser => _authUser.value;
  set setUser(AuthUserModel value) => _authUser.value = value;

  @override
  void onInit() {
    memo.runOnce(_initFunction);
    super.onInit();
  }

  Future<void> loggedIn(String token) async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    int idUser = decodedToken["id"];
    String userName = decodedToken["username"];
    String email = decodedToken["email"];
    String phone = decodedToken["phone"];
    String taxNumber = decodedToken["tax_number"];
    PositionEnum position = PositionEnum.values.firstWhere((e) => e.toString().split('.').last == decodedToken["position"]);
    PermissionEnum permission = PermissionEnum.values.firstWhere((e) => e.toString().split('.').last == decodedToken["permission"]);
    
    _authUser.update((authUser) {
      authUser!.isLoggedIn = true;
      authUser.token = token;
      authUser.userId = idUser;
      authUser.username = userName;
      authUser.email = email;
      authUser.phone = phone;
      authUser.taxNumber = taxNumber;
      authUser.position = position;
      authUser.permission = permission;
      authUser.admin = permission == PermissionEnum.ADMIN;
    });

    await Storage.instance.setStringValue("user", json.encode(getUser));
  }

  Future<void> setHospital(Hospital hospital) async {
    _authUser.update((authUser) {
      authUser!.hospital = hospital;
    });
    await Storage.instance.setStringValue("user", json.encode(getUser));

  }

  Future<void> logoutUser() async {
    await Storage.instance.removeValue("user");
    setUser = AuthUserModel();
    await Get.offAllNamed(Routes.signIn);
  }

  Future<AuthService> _initFunction() async {
    String storageUser = await Storage.instance.getStringValue("user");
    
    if (storageUser.isNotEmpty) {
      setUser = AuthUserModel.fromJson(json.decode(storageUser));
    }

    if (storageUser.isEmpty) {
      await Get.offAllNamed(Routes.signIn);
    } 
    return this;
  }

}
