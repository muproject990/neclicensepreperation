import 'dart:io';
import 'package:flutter/material.dart';
import 'package:neclicensepreperation/features/questions/widgets/pie_chart.dart';
import 'package:path_provider/path_provider.dart';
// import 'pie_chart_widget.dart'; // Ensure this is your PieChartWidget file

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  double averagePercentage = 0.0;

  @override
  void initState() {
    super.initState();
    loadStatistics();
  }

  Future<void> loadStatistics() async {
    final directory = await getApplicationDocumentsDirectory();
    final statsFile = File('${directory.path}/statistics.txt');

    if (await statsFile.exists()) {
      String fileContent = await statsFile.readAsString();
      List<String> lines = fileContent.split('\n');

      int totalQuestions = 0;

      for (String line in lines) {
        if (line.startsWith('Total Correct Answers:')) {
          correctAnswers += int.parse(line.split(':')[1].trim());
        } else if (line.startsWith('Total Questions:')) {
          totalQuestions += int.parse(line.split(':')[1].trim());
        }
      }

      incorrectAnswers =
          totalQuestions - correctAnswers; // Calculate incorrect answers

      if (totalQuestions > 0) {
        averagePercentage = (correctAnswers / totalQuestions) *
            100; // Calculate average percentage
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistics',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            PieChartWidget(
              correctAnswers: correctAnswers,
              incorrectAnswers: incorrectAnswers,
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Correct Answers: $correctAnswers'),
                    const SizedBox(height: 8),
                    Text('Total Incorrect Answers: $incorrectAnswers'),
                    const SizedBox(height: 8),
                    Text(
                        'Average Percentage: ${averagePercentage.toStringAsFixed(2)}%'), // Display average percentage
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
