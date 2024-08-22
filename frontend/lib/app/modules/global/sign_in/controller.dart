import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/core/routes/routes.dart';

import '../../../core/global_widgets/snackbar.dart';
import '../../../core/services/auth.dart';
import 'repository.dart';

class SignInController extends GetxController {
  SignInController({required this.signInRepository});

  final SignInRepository signInRepository;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var emailError = ''.obs;
  var passwordError = ''.obs;

  final RxBool loading = false.obs;
  bool get getLoading => loading.value;

  double getLogoOffset(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return keyboardVisible ? 20.0 : 60.0;
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<bool> formValidator() async {
    bool isValid = true;
    if (emailController.text.isEmpty ||
        !GetUtils.isEmail(emailController.text)) {
      emailError('Por favor, insira um email válido');
      loading.value = false;
      isValid = false;
    }
    if (passwordController.text.isEmpty) {
      passwordError('Por favor, insira sua senha');
      loading.value = false;
      isValid = false;
    }
    return isValid;
  }

  void login() async {
    loading.value = true;
    if (await formValidator()) {
      try {
        var response = await signInRepository.getUser({
          "email": emailController.text,
          "password": passwordController.text,
        });

        if (response.status!) {
          AuthService.to.loggedIn(response.token!);
          SnackBarApp.body(
            "Sucesso",
            "Login realizado com sucesso!",
          );
          Get.toNamed(Routes.home);
        } else {
          SnackBarApp.body("Ops!", "Email ou senha inválidos.",
              icon: FontAwesomeIcons.xmark);
        }
      } catch (e) {
        SnackBarApp.body("Ops!", "Não foi possível realizar o login.",
            icon: FontAwesomeIcons.xmark);
        throw Exception(e.runtimeType);
      } finally {
        loading.value = false;
      }
    }
  }

  Future<void> logout() async {
    AuthService.to.logoutUser();
  }
}
