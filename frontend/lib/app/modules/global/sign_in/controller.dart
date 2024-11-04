import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/core/routes/routes.dart';
import 'package:hospital_management/app/modules/global/core/model/signup_model.dart';
import '../../../core/global_widgets/snackbar.dart';
import '../../../core/services/auth.dart';
import 'repository.dart';

class SignInController extends GetxController {
  SignInController({required this.signInRepository});

  final SignInRepository signInRepository;

  // Controladores de texto
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final taxNumberController = TextEditingController();
  final uniqueCodeController = TextEditingController();
  final signUpPasswordController = TextEditingController();
  final fullNameController = TextEditingController();
  final signUpEmailController = TextEditingController();
  final positionController = TextEditingController();

  // Variáveis observáveis para erros
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var phoneError = ''.obs;
  var taxNumberError = ''.obs;
  var uniqueCodeError = ''.obs;
  var fullNameError = ''.obs;
  var signUpEmailError = ''.obs;
  var signUpPasswordError = ''.obs;
  var positionError = ''.obs;

  // Outras variáveis observáveis
  var position = 'Enfermeira'.obs;
  var isSignUpFormVisible = false.obs;
  var loading = false.obs;

  bool get getLoading => loading.value;

  double getLogoOffset(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return keyboardVisible ? 20.0 : 60.0;
  }

  @override
  void onInit() {
    super.onInit();
    emailController.text = '';
    passwordController.text = '';
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    taxNumberController.clear();
    uniqueCodeController.clear();
    fullNameController.clear();
    signUpEmailController.clear();
    signUpPasswordController.clear();

    emailError.value = '';
    passwordError.value = '';
    phoneError.value = '';
    taxNumberError.value = '';
    uniqueCodeError.value = '';
    fullNameError.value = '';
    signUpEmailError.value = '';
    signUpPasswordError.value = '';
    positionError.value = '';
  }

  void hideCredentials() {
    emailController.clear();
    passwordController.clear();
    emailError.value = '';
    passwordError.value = '';
  }

  Future<bool> formValidator() async {
    bool isValid = true;
    emailError.value = '';
    passwordError.value = '';

    if (emailController.text.isEmpty ||
        !GetUtils.isEmail(emailController.text)) {
      emailError.value = 'Por favor, insira um email válido';
      isValid = false;
    }
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Por favor, insira sua senha';
      isValid = false;
    }
    if (signUpEmailController.text.isEmpty ||
        !GetUtils.isEmail(signUpEmailController.text)) {
      signUpEmailError.value = 'Por favor, insira um email válido';
      isValid = false;
    }
    if (phoneController.text.isEmpty || phoneController.text.length < 11) {
      phoneError.value = 'Insira um número de celular válido';
      isValid = false;
    }
    if (signUpPasswordController.text.isEmpty) {
      signUpPasswordError.value = 'Por favor, insira uma senha';
      isValid = false;
    }
    if (passwordController.text.isEmpty || passwordController.text.length < 8) {
      passwordError.value = 'A senha deve ter pelo menos 8 caracteres';
      isValid = false;
    }
    if (taxNumberController.text.isEmpty ||
        taxNumberController.text.length != 11 ||
        !GetUtils.isNumericOnly(taxNumberController.text)) {
      taxNumberError.value = 'Insira um CPF válido com 11 dígitos';
      isValid = false;
    }
    if (uniqueCodeController.text.isEmpty ||
        uniqueCodeController.text.length < 4) {
      uniqueCodeError.value =
          'O código do hospital deve ter pelo menos 4 caracteres';
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
          SnackBarApp.body("Sucesso", "Login realizado com sucesso!");
          if (await getHospital()) {
            Get.offAllNamed(Routes.home);
          }
          clearFields();
        } else {
          SnackBarApp.body("Ops!", response.detail!,
              icon: FontAwesomeIcons.xmark);
        }
      } catch (e) {
        SnackBarApp.body("Ops!", "Não foi possível realizar o login.",
            icon: FontAwesomeIcons.xmark);
      } finally {
        loading.value = false;
      }
    } else {
      loading.value = false;
    }
  }

  void register() async {
    loading.value = true;
    if (await formValidator()) {
      try {
        final signupModel = SignupModel(
          name: fullNameController.text,
          email: signUpEmailController.text,
          phone: phoneController.text,
          taxNumber: taxNumberController.text,
          hospitalUniqueCode: uniqueCodeController.text,
          password: signUpPasswordController.text,
        );

        final response = await signInRepository.registerUser(signupModel);
        if (response.status) {
          SnackBarApp.body("Sucesso", "Cadastro realizado com sucesso!");
          toggleSignUpForm();
          clearFields();
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
    } else {
      loading.value = false;
    }
  }

  void toggleSignUpForm() {
    isSignUpFormVisible.value = !isSignUpFormVisible.value;
    if (isSignUpFormVisible.value) {
      hideCredentials();
    }
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
    hideCredentials();
  }
}
