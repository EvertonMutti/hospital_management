import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hospital_management/app/modules/home/controller.dart';

class NotificationPage extends GetView<HomeController> {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Notificações')),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: const Icon(
                        FontAwesomeIcons.solidBell,
                        color: Colors.yellow,
                        size: 50,
                      ),
                    ),
                    Transform.rotate(
                      angle: -0.785398,
                      child: Container(
                        width: 90,
                        height: 5,
                        color: Colors.yellow,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sem notificações',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            final formattedDate = controller.formatDate(notification.date!);
            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              leading: const Icon(
                FontAwesomeIcons.solidBell,
                color: Colors.blue,
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(notification.body!),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  controller.removeNotification(index);
                },
              ),
            );
          },
        );
      }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.clearNotifications();
        },
        backgroundColor: Colors.red,
        tooltip: 'Limpar Notificações',
        child: const Icon(Icons.clear_all),
      ),
    );
  }
}
