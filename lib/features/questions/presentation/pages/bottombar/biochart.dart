import 'dart:io';
import 'package:flutter/material.dart';
import 'package:neclicensepreperation/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class StatisticsChart extends StatefulWidget {
  @override
  _StatisticsChartState createState() => _StatisticsChartState();
}

class _StatisticsChartState extends State<StatisticsChart> {
  List<int> totalQuestionsList = [];
  List<int> totalCorrectAnswersList = [];
  List<double> percentageCorrectList = [];

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final directory = await getApplicationDocumentsDirectory();
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      final userId = appUserState.user.id;
      final statsFile = File('${directory.path}/statistics_$userId.txt');

      try {
        if (await statsFile.exists()) {
          final fileContent = await statsFile.readAsString();
          _parseStatistics(fileContent);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No statistics file found for this user.")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error reading statistics: ${e.toString()}")),
        );
      }
    }
  }

  void _parseStatistics(String fileContent) {
    final lines = fileContent.trim().split('\n---\n');
    for (var line in lines) {
      final questionMatch = RegExp(r'Total Questions: (\d+)').firstMatch(line);
      final correctMatch =
          RegExp(r'Total Correct Answers: (\d+)').firstMatch(line);
      final percentageMatch =
          RegExp(r'Percentage Correct: ([\d.]+)').firstMatch(line);

      if (questionMatch != null &&
          correctMatch != null &&
          percentageMatch != null) {
        totalQuestionsList.add(int.parse(questionMatch.group(1)!));
        totalCorrectAnswersList.add(int.parse(correctMatch.group(1)!));
        percentageCorrectList.add(double.parse(percentageMatch.group(1)!));
      }
    }

    setState(() {}); // Update the UI after parsing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics Chart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: totalQuestionsList.isEmpty
            ? Center(child: Text("No data available"))
            : BarChart(
                BarChartData(
                  barGroups: _createBarGroups(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (index, _) =>
                            Text('Quiz ${index.toInt() + 1}'),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  List<BarChartGroupData> _createBarGroups() {
    return List.generate(totalQuestionsList.length, (index) {
      // Calculate the correct and incorrect percentages
      final correctPercentage = percentageCorrectList[index];
      final incorrectPercentage = 100 - correctPercentage;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: 100, // Stack up to 100% for each quiz
            rodStackItems: [
              // Correct answers segment
              BarChartRodStackItem(
                0, // Starting point of the correct segment
                correctPercentage, // End of the correct segment
                Colors.green, // Color for correct answers
              ),
              // Incorrect answers segment
              BarChartRodStackItem(
                correctPercentage, // Start of the incorrect segment
                100, // End up to 100% for incorrect answers
                Colors.red, // Color for incorrect answers
              ),
            ],
            width: 15,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }
}
