import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/core/utils/colors.dart';
import 'package:hospital_management/app/core/utils/size.dart';
import 'package:hospital_management/app/modules/global/core/widget/mh_logo.dart';
import 'controller.dart';

class SignInPage extends GetView<SignInController> {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 600 ? 24.0 : 48.0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[50], // Cor de fundo moderna e clara
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxPageWidth),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  margin: EdgeInsets.only(top: controller.getLogoOffset(context)),
                  child: const MHLogo(),
                ),
                const SizedBox(height: 40),
                // Campo de Email
                Obx(() => _buildTextField(
                      controller.emailController,
                      'Email',
                      icon: Icons.email_outlined,
                      errorText: controller.emailError.value,
                    )),
                const SizedBox(height: 20),
                // Campo de Senha
                Obx(() => _buildTextField(
                      controller.passwordController,
                      'Senha',
                      isPassword: true,
                      icon: Icons.lock_outline,
                      errorText: controller.passwordError.value,
                    )),
                const SizedBox(height: 34),
                // Botão de Login
                Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.getLoading ? null : controller.login,
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          backgroundColor: weakPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: controller.getLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    )),
                const SizedBox(height: 20),
                // Botão para Alternar para o Cadastro
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      controller.toggleSignUpForm();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      side: BorderSide(color: weakPrimaryColor, width: 2.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
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
                const SizedBox(height: 10),
                // Formulário de Cadastro
                Obx(() => Visibility(
                      visible: controller.isSignUpFormVisible.value,
                      child: Column(
                        children: [
                          _buildTextField(controller.fullNameController, 'Nome Completo', icon: Icons.person_outline),
                          const SizedBox(height: 20),
                          _buildTextField(controller.signUpEmailController, 'E-mail', icon: Icons.email_outlined),
                          const SizedBox(height: 20),
                          _buildTextField(controller.phoneController, 'Número de Telefone', icon: Icons.phone_outlined),
                          const SizedBox(height: 20),
                          _buildTextField(controller.cpfController, 'CPF', icon: Icons.badge_outlined),
                          const SizedBox(height: 20),
                          _buildTextField(controller.uniqueCodeController, 'Código único do hospital', icon: Icons.code_outlined),
                          const SizedBox(height: 20),
                          _buildTextField(controller.signUpPasswordController, 'Senha', isPassword: true, icon: Icons.lock_outline),
                          const SizedBox(height: 34),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: controller.register,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14.0),
                                backgroundColor: weakPrimaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
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
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool isPassword = false, IconData? icon, String? errorText}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        prefixIcon: icon != null ? Icon(icon) : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}
