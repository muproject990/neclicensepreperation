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
            : ListView.builder(
                itemCount: totalQuestionsList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Text(
                        'Quiz ${index + 1}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: _generatePieSections(index),
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
      ),
    );
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
