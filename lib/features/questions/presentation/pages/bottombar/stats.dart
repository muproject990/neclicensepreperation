import 'dart:io';
import 'package:flutter/material.dart';
import 'package:neclicensepreperation/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class StatisticsChart extends StatefulWidget {
  final String data;

  const StatisticsChart({super.key, required this.data});
  @override
  _StatisticsChartState createState() => _StatisticsChartState();
}

class _StatisticsChartState extends State<StatisticsChart> {
  List<int> totalQuestionsList = [];
  List<int> totalCorrectAnswersList = [];
  List<double> percentageCorrectList = [];
  double averageAccuracy = 0.0; // New variable for storing average accuracy

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
      final statsFile = File('${directory.path}/${widget.data}$userId.txt');
      print(statsFile.toString());

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
      final accuracyMatch = RegExp(r'Accuracy: ([\d.]+)').firstMatch(line);
      final percentageMatch = RegExp(r'Correct: ([\d.]+)%').firstMatch(line);

      if (questionMatch != null &&
          correctMatch != null &&
          accuracyMatch != null &&
          percentageMatch != null) {
        totalQuestionsList.add(int.parse(questionMatch.group(1)!));
        totalCorrectAnswersList.add(int.parse(correctMatch.group(1)!));
        percentageCorrectList.add(double.parse(percentageMatch.group(1)!));
      }
    }
    // Calculate the average accuracy after parsing all statistics
    if (percentageCorrectList.isNotEmpty) {
      averageAccuracy = percentageCorrectList.reduce((a, b) => a + b) /
          percentageCorrectList.length;
    }
    setState(() {}); // Update the UI after parsing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Success Rate: ${averageAccuracy.toStringAsFixed(1)}%"),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: ListView.builder(
        itemCount: totalQuestionsList.length,
        itemBuilder: (context, index) {
          return _buildQuizStatisticsCard(index);
        },
      ),
    );
  }

  Widget _buildQuizStatisticsCard(int index) {
    final totalQuestions = totalQuestionsList[index];
    final correctAnswers = totalCorrectAnswersList[index];
    final percentageCorrect = percentageCorrectList[index];
    final incorrectAnswers = totalQuestions - correctAnswers;

    return Card(
      margin: EdgeInsets.all(16),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quiz Number and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quiz ${index + 1}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[700],
                  ),
                ),
                Text(
                  DateTime.now().toString().split(' ')[0],
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Statistics Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.quiz,
                  label: 'Total Questions',
                  value: totalQuestions.toString(),
                  color: Colors.blue,
                ),
                _buildStatItem(
                  icon: Icons.check_circle,
                  label: 'Correct',
                  value: correctAnswers.toString(),
                  color: Colors.green,
                ),
                _buildStatItem(
                  icon: Icons.cancel,
                  label: 'Incorrect',
                  value: incorrectAnswers.toString(),
                  color: Colors.red,
                ),
              ],
            ),
            SizedBox(height: 16),

            // Percentage and Pie Chart
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 150,
                    child: PieChart(
                      PieChartData(
                        sections: _generatePieSections(index),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Accuracy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${percentageCorrect.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _getAccuracyColor(percentageCorrect),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy < 30) return Colors.red;
    if (accuracy < 50) return Colors.orange;
    if (accuracy < 70) return Colors.amber;
    if (accuracy < 85) return Colors.green;
    return Colors.green[700]!;
  }

  List<PieChartSectionData> _generatePieSections(int index) {
    final correctPercentage = percentageCorrectList[index];
    final incorrectPercentage = 100 - correctPercentage;

    return [
      PieChartSectionData(
        value: correctPercentage,
        color: Colors.green,
        title: '${correctPercentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: incorrectPercentage,
        color: Colors.red,
        title: '${incorrectPercentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }
}
