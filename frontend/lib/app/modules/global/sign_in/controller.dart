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

  // Controladores de texto para os campos de entrada
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final signUpEmailController = TextEditingController();
  final phoneController = TextEditingController();
  final cpfController = TextEditingController();
  final uniqueCodeController = TextEditingController();
  final signUpPasswordController = TextEditingController();

  // Observáveis para gerenciamento de estado
  final emailError = ''.obs;
  final passwordError = ''.obs;
  final signUpEmailError = ''.obs;
  final signUpPasswordError = ''.obs;
  final loading = false.obs;
  final isSignUpFormVisible = false.obs;

  bool get getLoading => loading.value;

  @override
  void onClose() {
    // Liberar recursos quando o controller for fechado
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    signUpEmailController.dispose();
    phoneController.dispose();
    cpfController.dispose();
    uniqueCodeController.dispose();
    signUpPasswordController.dispose();
    super.onClose();
  }

  double getLogoOffset(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return keyboardVisible ? 20.0 : 60.0;
  }

  Future<bool> formValidator() async {
    bool isValid = true;
    emailError.value = '';
    passwordError.value = '';

    if (emailController.text.isEmpty || !GetUtils.isEmail(emailController.text)) {
      emailError.value = 'Por favor, insira um email válido';
      isValid = false;
    }
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Por favor, insira sua senha';
      isValid = false;
    }

    loading.value = false;
    return isValid;
  }

  Future<bool> signUpFormValidator() async {
    bool isValid = true;
    signUpEmailError.value = '';
    signUpPasswordError.value = '';

    if (signUpEmailController.text.isEmpty || !GetUtils.isEmail(signUpEmailController.text)) {
      signUpEmailError.value = 'Por favor, insira um email válido';
      isValid = false;
    }
    if (signUpPasswordController.text.isEmpty) {
      signUpPasswordError.value = 'Por favor, insira uma senha';
      isValid = false;
    }

    loading.value = false;
    return isValid;
  }

  void login() async {
    loading.value = true;
    if (await formValidator()) {
      try {
        final response = await signInRepository.getUser({
          "email": emailController.text,
          "password": passwordController.text,
        });

        if (response.status!) {
          AuthService.to.loggedIn(response.token!);
          SnackBarApp.body("Sucesso", "Login realizado com sucesso!");
          Get.offAllNamed(Routes.home);
        } else {
          SnackBarApp.body("Ops!", "Email ou senha inválidos.", icon: FontAwesomeIcons.xmark);
        }
      } catch (e) {
        SnackBarApp.body("Ops!", "Não foi possível realizar o login.", icon: FontAwesomeIcons.xmark);
      } finally {
        loading.value = false;
      }
    }
  }

  void register() async {
    loading.value = true;
    if (await signUpFormValidator()) {
      try {
        final response = await signInRepository.registerUser({
          "fullName": fullNameController.text,
          "email": signUpEmailController.text,
          "phone": phoneController.text,
          "cpf": cpfController.text,
          "uniqueCode": uniqueCodeController.text,
          "password": signUpPasswordController.text,
        });

        if (response.status!) {
          SnackBarApp.body("Sucesso", "Cadastro realizado com sucesso!");
          toggleSignUpForm(); // Alterna para a tela de login
        } else {
          SnackBarApp.body("Ops!", "Falha ao realizar o cadastro.", icon: FontAwesomeIcons.xmark);
        }
      } catch (e) {
        SnackBarApp.body("Ops!", "Não foi possível realizar o cadastro.", icon: FontAwesomeIcons.xmark);
      } finally {
        loading.value = false;
      }
    }
  }

  void toggleSignUpForm() {
    isSignUpFormVisible.value = !isSignUpFormVisible.value;
  }

  Future<void> logout() async {
    AuthService.to.logoutUser();
  }
}

extension on SignInRepository {
  registerUser(Map<String, String> map) {}
}
