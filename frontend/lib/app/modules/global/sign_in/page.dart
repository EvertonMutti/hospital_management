import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/core/global_widgets/progress_indicator.dart';
import 'package:hospital_management/app/core/utils/colors.dart';
import 'package:hospital_management/app/core/utils/size.dart';
import 'package:hospital_management/app/modules/global/core/Enum/scopes.dart';
import 'package:hospital_management/app/modules/global/core/widget/mh_logo.dart';
import 'controller.dart';

class SignInPage extends GetView<SignInController> {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxPageWidth),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                              margin: EdgeInsets.only(
                                top: controller.getLogoOffset(context),
                              ),
                              child: const MHLogo(),
                            ),
                            const SizedBox(height: 80),
                            // Esconde campos de login quando o formulário de cadastro estiver visível
                            Obx(() => Visibility(
                                  visible:
                                      !controller.isSignUpFormVisible.value,
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: controller.emailController,
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          errorText: controller
                                                  .emailError.value.isNotEmpty
                                              ? controller.emailError.value
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextField(
                                        controller:
                                            controller.passwordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: 'Senha',
                                          errorText: controller.passwordError
                                                  .value.isNotEmpty
                                              ? controller.passwordError.value
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(height: 34),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: controller.getLoading
                                              ? null
                                              : controller.login,
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12.0),
                                            backgroundColor: weakPrimaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                          ),
                                          child: const Text(
                                            'Login',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            const SizedBox(height: 20),
                            // Botão para alternar entre os formulários
                            Obx(() => Visibility(
                                  visible:
                                      !controller.isSignUpFormVisible.value,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        controller.toggleSignUpForm();
                                      },
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        side: const BorderSide(
                                            color: weakPrimaryColor,
                                            width: 2.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                      ),
                                      child: const Text(
                                        'Cadastre-se',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: weakPrimaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                            // Formulário de Cadastro
                            Obx(() => Visibility(
                                  visible: controller.isSignUpFormVisible.value,
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller:
                                            controller.fullNameController,
                                        decoration: InputDecoration(
                                          labelText: 'Nome Completo',
                                          errorText: controller.fullNameError
                                                  .value.isNotEmpty
                                              ? controller.fullNameError.value
                                              : null,
                                          prefixIcon:
                                              const Icon(Icons.person_outline),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: const BorderSide(
                                                color: Colors.redAccent),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextField(
                                        controller:
                                            controller.signUpEmailController,
                                        decoration: InputDecoration(
                                          labelText: 'E-mail',
                                          errorText: controller.signUpEmailError
                                                  .value.isNotEmpty
                                              ? controller
                                                  .signUpEmailError.value
                                              : null,
                                          prefixIcon:
                                              const Icon(Icons.email_outlined),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: const BorderSide(
                                                color: Colors.redAccent),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextField(
                                        controller: controller.phoneController,
                                        decoration: InputDecoration(
                                          labelText: 'Número de Telefone',
                                          errorText: controller
                                                  .phoneError.value.isNotEmpty
                                              ? controller.phoneError.value
                                              : null,
                                          prefixIcon:
                                              const Icon(Icons.phone_outlined),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: const BorderSide(
                                                color: Colors.redAccent),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextField(
                                        controller:
                                            controller.taxNumberController,
                                        decoration: InputDecoration(
                                          labelText: 'CPF',
                                          errorText: controller.taxNumberError
                                                  .value.isNotEmpty
                                              ? controller.taxNumberError.value
                                              : null,
                                          prefixIcon:
                                              const Icon(Icons.badge_outlined),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: const BorderSide(
                                                color: Colors.redAccent),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextField(
                                        controller:
                                            controller.uniqueCodeController,
                                        decoration: InputDecoration(
                                          labelText: 'Código único do hospital',
                                          errorText: controller.uniqueCodeError
                                                  .value.isNotEmpty
                                              ? controller.uniqueCodeError.value
                                              : null,
                                          prefixIcon:
                                              const Icon(Icons.code_outlined),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: const BorderSide(
                                                color: Colors.redAccent),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextField(
                                        controller:
                                            controller.signUpPasswordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: 'Senha',
                                          errorText: controller
                                                  .signUpPasswordError
                                                  .value
                                                  .isNotEmpty
                                              ? controller
                                                  .signUpPasswordError.value
                                              : null,
                                          prefixIcon:
                                              const Icon(Icons.lock_outline),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: const BorderSide(
                                                color: Colors.redAccent),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      DropdownButtonFormField<PositionEnum>(
                                        value:
                                            controller.selectedPosition.value,
                                        items:
                                            PositionEnum.values.map((position) {
                                          return DropdownMenuItem<PositionEnum>(
                                            value: position,
                                            child: Text(
                                              _translatePosition(position),
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (PositionEnum? newPosition) {
                                          controller.setSelectedPosition =
                                              newPosition!;
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Posição',
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 16.0,
                                                  horizontal: 12.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 1.0),
                                          ),
                                        ),
                                        dropdownColor: Colors.grey
                                            .shade50, // Cor do fundo do menu dropdown
                                      ),
                                      const SizedBox(height: 40),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: controller.register,
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14.0),
                                            backgroundColor: weakPrimaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                          ),
                                          child: const Text(
                                            'Registrar',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      // Botão para voltar ao login
                                      SizedBox(
                                        width: double.infinity,
                                        child: OutlinedButton(
                                          onPressed: () {
                                            controller.toggleSignUpForm();
                                          },
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12.0),
                                            side: const BorderSide(
                                                color: weakPrimaryColor,
                                                width: 2.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                          ),
                                          child: const Text(
                                            'Voltar ao Login',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: weakPrimaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Obx(() {
            if (controller.getLoading) {
              return Container(
                color: Colors.black54,
                child: const Center(
                  child: ProgressIndicatorApp(),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }

  String _translatePosition(PositionEnum position) {
    switch (position) {
      case PositionEnum.NURSE:
        return 'Enfermeiro';
      case PositionEnum.CLEANER:
        return 'Faxineiro';
      default:
        return '';
    }
  }
}
