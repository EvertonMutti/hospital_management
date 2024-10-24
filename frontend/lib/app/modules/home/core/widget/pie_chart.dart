import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:hospital_management/app/modules/home/home/controller.dart';
import 'package:hospital_management/app/modules/home/core/widget/indicator.dart';

class ExpandablePieChartWidget extends GetView<HomeController> {
  const ExpandablePieChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: controller.toggleChartExpand,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.all(controller.isChartExpanded.value ? 8.0 : 4.0),
          constraints: BoxConstraints(
            maxWidth: double.infinity,
            maxHeight: controller.chartSize,
          ),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: controller.isChartExpanded.value ? 6 : 4,
                blurRadius: controller.isChartExpanded.value ? 12 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: controller.getLoading
              ? const Center(child: CircularProgressIndicator()) 
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: SizedBox(
                  width: controller.chartSize,
                  height: controller.chartSize,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: controller.centerSpaceRadius,
                      sections: showingSections(),
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          if (event is FlTapUpEvent &&
                              pieTouchResponse != null &&
                              pieTouchResponse.touchedSection != null) {
                            final tappedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                            controller.handlePieTouch(tappedIndex);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Indicator(
                    color: Colors.green,
                    text: 'Leitos Livres',
                    isSquare: true,
                  ),
                  SizedBox(height: 4),
                  Indicator(
                    color: Colors.red,
                    text: 'Leitos em Uso',
                    isSquare: true,
                  ),
                  SizedBox(height: 4),
                  Indicator(
                    color: Colors.yellow,
                    text: 'Leitos em Manutenção',
                    isSquare: true,
                  ),
                  Indicator(
                    color: Colors.blue,
                    text: 'Leitos em Limpeza',
                    isSquare: true,
                  ),
                  Indicator(
                    color: Color.fromARGB(255, 26, 110, 150),
                    text: 'Leitos necessitando de limpeza',
                    isSquare: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(5, (i) {
      final isTouched = i == controller.selectedSection.value;
      final fontSize = isTouched ? 20.0 : 12.0;
      final radius = isTouched ? 50.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.red,
            value: controller.calculatePercentage(controller.countBed.value.occupied!.toDouble()),
            title: '${controller.calculatePercentage(controller.countBed.value.occupied!.toDouble()).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.green,
            value: controller.calculatePercentage(controller.countBed.value.free!.toDouble()),
            title: '${controller.calculatePercentage(controller.countBed.value.free!.toDouble()).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color:Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.yellow,
            value: controller.calculatePercentage(controller.countBed.value.maintenance!.toDouble()),
            title: '${controller.calculatePercentage(controller.countBed.value.maintenance!.toDouble()).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: const Color.fromARGB(255, 26, 110, 150),
            value: controller.calculatePercentage(controller.countBed.value.cleaningRequired!.toDouble()),
            title: '${controller.calculatePercentage(controller.countBed.value.cleaningRequired!.toDouble()).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 4:
          return PieChartSectionData(
            color: Colors.blue,
            value: controller.calculatePercentage(controller.countBed.value.cleaning!.toDouble()),
            title: '${controller.calculatePercentage(controller.countBed.value.cleaning!.toDouble()).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color:Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
