import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/core/routes/routes.dart';
import 'package:hospital_management/app/core/services/sqflite.dart';
import 'package:hospital_management/app/core/utils/system.dart';
import 'package:hospital_management/app/modules/global/core/model/signup_model.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/global_widgets/snackbar.dart';
import '../../../core/services/auth.dart';
import 'repository.dart';

class SignInController extends GetxController {
  SignInController({required this.signInRepository});

  final SignInRepository signInRepository;

  final SignupService signupService = SignupService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var emailError = ''.obs;
  var passwordError = ''.obs;

  final phoneController = TextEditingController();
  var phoneError = ''.obs;
  final taxNumberController = TextEditingController();
  var taxNumberError = ''.obs;
  final uniqueCodeController = TextEditingController();
  var uniqueCodeError = ''.obs;
  final signUpPasswordController = TextEditingController();
  var signUpEmailError = ''.obs;
  final fullNameController = TextEditingController();
  var fullNameError = ''.obs;
  final signUpEmailController = TextEditingController();
  var signUpPasswordError = ''.obs;

  final isSignUpFormVisible = false.obs;

  final RxBool loading = false.obs;
  bool get getLoading => loading.value;

  double getLogoOffset(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return keyboardVisible ? 20.0 : 60.0;
  }

  @override
  void onInit() {
    super.onInit();
    emailController.text = 'carlos.admin@example.com';
    passwordController.text = 'admin123';
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    if (Platform.isAndroid && (await SystemInfo.isAndroid11OrHigher())) {
      await Permission.manageExternalStorage.request();
    } else {
      await Permission.storage.request();
    }
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
          if (await getHospital()) {
            Get.offAllNamed(Routes.home);
          }
        } else {
          SnackBarApp.body("Ops!", response.detail!,
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

  Future<bool> signUpFormValidator() async {
    bool isValid = true;
    emailError.value = '';
    passwordError.value = '';

    if (signUpEmailController.text.isEmpty ||
        !GetUtils.isEmail(signUpEmailController.text)) {
      emailError.value = 'Por favor, insira um email válido';
      isValid = false;
    }
    if (signUpPasswordController.text.isEmpty) {
      passwordError.value = 'Por favor, insira uma senha';
      isValid = false;
    }

    loading.value = false;
    return isValid;
  }

  void register() async {
    loading.value = true;
    if (await signUpFormValidator()) {
      try {
        // Cria o modelo com os dados preenchidos
        final signupModel = SignupModel(
          name: fullNameController.text,
          email: signUpEmailController.text,
          phone: phoneController.text,
          taxNumber: taxNumberController.text,
          hospitalUniqueCode: uniqueCodeController.text,
          password: signUpPasswordController.text,
        );

        // Chama o repositório com o modelo criado
        final response = await signInRepository.registerUser(signupModel);

        if (response.status) {
          await signupService.insertSignup(signupModel);
          SnackBarApp.body("Sucesso", "Cadastro realizado com sucesso!");
          toggleSignUpForm(); // Alterna para a tela de login
        } else {
          SnackBarApp.body("Ops!", "Falha ao realizar o cadastro.",
              icon: FontAwesomeIcons.xmark);
        }
      } catch (e) {
        SnackBarApp.body("Ops!", "Não foi possível realizar o cadastro.",
            icon: FontAwesomeIcons.xmark);
      } finally {
        loading.value = false;
      }
    }
  }

  void toggleSignUpForm() {
    isSignUpFormVisible.value = !isSignUpFormVisible.value;
  }

  Future<bool> getHospital() async {
    var hospitalResponse = await signInRepository.getHospital();
    if (hospitalResponse.status!) {
      if (hospitalResponse.data!.isNotEmpty &&
          hospitalResponse.data!.length == 1) {
        AuthService.to.setHospital(hospitalResponse.data![0]);
        return true;
      }
    } else {
      SnackBarApp.body("Ops!", hospitalResponse.detail!,
          icon: FontAwesomeIcons.xmark);
    }
    return false;
  }

  Future<void> logout() async {
    AuthService.to.logoutUser();
  }
}
