import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  final int correctAnswers;
  final int incorrectAnswers;

  const PieChartWidget({
    Key? key,
    required this.correctAnswers,
    required this.incorrectAnswers,
  }) : super(key: key);


// nkbkj
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250, // Define a height for the PieChart
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: correctAnswers.toDouble(),
              title: '$correctAnswers',
              color: const Color.fromARGB(255, 21, 10, 14),
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              value: incorrectAnswers.toDouble(),
              title: '$incorrectAnswers',
              color: Colors.red,
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }
}
