import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class StatisticsPages extends StatelessWidget {
  final String username;

  const StatisticsPages({Key? key, required this.username}) : super(key: key);

  Future<String> _loadStatistics() async {
    final directory = await getApplicationDocumentsDirectory();
    final statsFile = File('${directory.path}/$username.txt');

    if (await statsFile.exists()) {
      return await statsFile.readAsString();
    }
    return "No statistics available.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
      ),
      body: FutureBuilder<String>(
        future: _loadStatistics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Text(
                  snapshot.data!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
