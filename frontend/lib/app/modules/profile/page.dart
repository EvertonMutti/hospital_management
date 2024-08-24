import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/core/utils/size.dart';
import 'package:hospital_management/app/modules/profile/controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});
  

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxPageWidth),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Tooltip(
                  message: 'Não é possível editar o perfil.',
                  child: TextButton(
                    onPressed: null, 
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                    ),
                    child: const Text(
                      'Editar Perfil',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    controller.logout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50), // Largura máxima
                  ),
                  child: const Text(
                    'Sair',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
