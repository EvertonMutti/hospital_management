import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/core/routes/routes.dart';
import 'package:hospital_management/app/core/utils/size.dart';
import 'package:hospital_management/app/modules/home/core/widget/list_beds.dart';
import 'package:hospital_management/app/modules/home/core/widget/pie_chart.dart';
import 'controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox(),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications),
                Obx(() {
                  if (controller.notificationCount.value > 0) {
                    return Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '${controller.notificationCount.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
            onPressed: () {
              controller.clearNotifications();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () {
                Get.toNamed(Routes.profile);
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxPageWidth),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status dos Leitos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ExpandablePieChartWidget(),
                SizedBox(height: 30),
                Text(
                  'Lista de Leitos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListBedsWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
