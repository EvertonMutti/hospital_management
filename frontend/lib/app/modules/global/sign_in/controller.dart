import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/core/config/config.dart';
import 'package:hospital_management/app/core/routes/routes.dart';
import 'package:hospital_management/app/core/services/sqflite.dart';
import 'package:hospital_management/app/core/utils/system.dart';
import 'package:hospital_management/app/modules/global/core/Enum/scopes.dart';
import 'package:hospital_management/app/modules/global/core/model/signup_model.dart';

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
  final Rx<PositionEnum> selectedPosition = PositionEnum.NURSE.obs;
  get getSelectedPosition => selectedPosition.value;
  set setSelectedPosition(PositionEnum value) => selectedPosition.value = value;

  final isSignUpFormVisible = false.obs;

  final RxBool loading = false.obs;
  bool get getLoading => loading.value;

  double getLogoOffset(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return keyboardVisible ? 20.0 : 60.0;
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    // await SystemInfo.requestStoragePermission();
    emailController.text =
        Enviroment.env != 'PROD' ? 'carlos.admin@example.com' : '';
    passwordController.text = Enviroment.env != 'PROD' ? 'admin123' : '';
  }

  void clearFields() {
    clearLoginFields();
    clearSignupFields();
  }

  void clearLoginErrorMessages() {
    emailError.value = '';
    passwordError.value = '';
  }

  void clearLoginFields() {
    emailController.clear();
    passwordController.clear();

    clearLoginErrorMessages();
  }

  void clearSignupErrorMessages() {
    phoneError.value = '';
    taxNumberError.value = '';
    uniqueCodeError.value = '';
    fullNameError.value = '';
    signUpEmailError.value = '';
    signUpPasswordError.value = '';
  }

  void clearSignupFields() {
    phoneController.clear();
    taxNumberController.clear();
    uniqueCodeController.clear();
    fullNameController.clear();
    signUpEmailController.clear();
    signUpPasswordController.clear();

    clearSignupErrorMessages();
  }

  Future<bool> formValidator() async {
    bool isValid = true;
    if (emailController.text.isEmpty ||
        !GetUtils.isEmail(emailController.text)) {
      emailError('Por favor, insira um email válido');
      isValid = false;
    }
    if (passwordController.text.isEmpty) {
      passwordError('Por favor, insira sua senha');
      isValid = false;
    }
    loading.value = isValid;
    return isValid;
  }

  void login() async {
    loading.value = true;
    clearLoginErrorMessages();
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
          SnackBarApp.body(
              "Ops!", response.detail ?? "Não foi possível realizar o login.",
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

    if (signUpEmailController.text.isEmpty ||
        !GetUtils.isEmail(signUpEmailController.text)) {
      signUpEmailError.value = 'Por favor, insira um email válido';
      isValid = false;
    }
    if (signUpPasswordController.text.isEmpty) {
      signUpPasswordError.value = 'Por favor, insira uma senha';
      isValid = false;
    }
    if (phoneController.text.isEmpty || phoneController.text.length < 11) {
      phoneError.value = 'Insira um número de celular válido';
      isValid = false;
    }
    if (taxNumberController.text.isEmpty ||
        taxNumberController.text.length != 11 ||
        !GetUtils.isNumericOnly(taxNumberController.text)) {
      taxNumberError.value = 'Insira um CPF válido com 11 dígitos';
      isValid = false;
    }
    if (uniqueCodeController.text.isEmpty ||
        uniqueCodeController.text.length < 6) {
      uniqueCodeError.value =
          'O código do hospital deve ter pelo menos 6 caracteres';
      isValid = false;
    }
    if (fullNameController.text.isEmpty) {
      fullNameError.value = 'Por favor, insira um nome';
      isValid = false;
    }

    loading.value = isValid;
    return isValid;
  }

  void register() async {
    loading.value = true;
    clearSignupErrorMessages();
    if (await signUpFormValidator()) {
      try {
        final signupModel = SignupModel(
          name: fullNameController.text,
          email: signUpEmailController.text,
          phone: phoneController.text,
          taxNumber: taxNumberController.text,
          hospitalUniqueCode: uniqueCodeController.text,
          password: signUpPasswordController.text,
          position: _convertPosition(getSelectedPosition),
        );

        final response = await signInRepository.registerUser(signupModel);

        if (response.status) {
          await signupService.insertSignup(signupModel);
          SnackBarApp.body("Sucesso", "Cadastro realizado com sucesso!");
          toggleSignUpForm();
        } else {
          SnackBarApp.body(
              "Ops!", response.detail ?? "Erro ao realizar cadastro",
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
    clearFields();
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
      SnackBarApp.body(
          "Ops!", hospitalResponse.detail ?? "Erro ao buscar hospital",
          icon: FontAwesomeIcons.xmark);
      await logout();
    }
    return false;
  }

  Future<void> logout() async {
    AuthService.to.logoutUser();
  }

  String _convertPosition(PositionEnum position) {
    switch (position) {
      case PositionEnum.NURSE:
        return 'NURSE';
      case PositionEnum.CLEANER:
        return 'CLEANER';
      default:
        return '';
    }
  }
}
