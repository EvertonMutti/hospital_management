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
          padding: EdgeInsets.all(controller.isChartExpanded.value ? 4.0 : 0.0),
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
          child: controller.getLoading || controller.countBed.value.areAttributesEmpty()
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
                      borderData: FlBorderData(
                    show: false,
                  ),
                    ),
                  ),
                ),
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Indicator(
                    color: Colors.green,
                    text: 'Leitos Livres ',
                    isSquare: true,
                  ),
                  SizedBox(height: 5),
                  Indicator(
                    color: Colors.red,
                    text: 'Leitos em Uso ',
                    isSquare: true,
                  ),
                  SizedBox(height: 5),
                  Indicator(
                    color: Colors.yellow,
                    text: 'Leitos em\nManutenção',
                    isSquare: true,
                  ),
                  SizedBox(height: 5),
                  Indicator(
                    color: Colors.blue,
                    text: 'Leitos em\nLimpeza',
                    isSquare: true,
                  ),
                  SizedBox(height: 5),
                  Indicator(
                    color: Color.fromARGB(255, 26, 110, 150),
                    text: 'Leitos\nnecessitando \nde limpeza',
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
      final fontSize = isTouched ? 18.0 : 10.0;
      final radius = isTouched ? 50.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      double getValueOrDefault(int? value) {
        return value?.toDouble() ?? 0.0;
      }

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.red,
            value: controller.calculatePercentage(getValueOrDefault(controller.countBed.value.occupied)),
            title: '${controller.calculatePercentage(getValueOrDefault(controller.countBed.value.occupied)).toStringAsFixed(1)}%',
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
            value: controller.calculatePercentage(getValueOrDefault(controller.countBed.value.free)),
            title: '${controller.calculatePercentage(getValueOrDefault(controller.countBed.value.free)).toStringAsFixed(1)}%',
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
            value: controller.calculatePercentage(getValueOrDefault(controller.countBed.value.maintenance)),
            title: '${controller.calculatePercentage(getValueOrDefault(controller.countBed.value.maintenance)).toStringAsFixed(1)}%',
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
            value: controller.calculatePercentage(getValueOrDefault(controller.countBed.value.cleaningRequired)),
            title: '${controller.calculatePercentage(getValueOrDefault(controller.countBed.value.cleaningRequired)).toStringAsFixed(1)}%',
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
            value: controller.calculatePercentage(getValueOrDefault(controller.countBed.value.cleaning)),
            title: '${controller.calculatePercentage(getValueOrDefault(controller.countBed.value.cleaning)).toStringAsFixed(1)}%',
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
