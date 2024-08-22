import 'dart:async';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:async/async.dart';
import 'package:get/get.dart';
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

    String userName = decodedToken["name"].split(" ").first;
    int idUser = decodedToken["id"];

    _authUser.update((authUser) {
      authUser!.isLoggedIn = true;
      authUser.token = token;
      authUser.userId = idUser;
      authUser.username = userName;
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
      await Get.toNamed(Routes.signIn);
    } 
    return this;
  }

}
