import 'package:flutter/material.dart';

class AccuracyProgressDisplay extends StatelessWidget {
  final double userAccuracy;
  final int answeredCount;
  final int totalQuestions;

  const AccuracyProgressDisplay({
    required this.userAccuracy,
    required this.answeredCount,
    required this.totalQuestions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.speed, size: 16, color: Colors.white70),
            const SizedBox(width: 5),
            Text(
              'Accuracy: ${userAccuracy.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 14,
                color: userAccuracy < 50
                    ? Colors.red
                    : userAccuracy < 70
                        ? Colors.orange
                        : Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(width: 15),
        Row(
          children: [
            const Icon(Icons.check_circle_outline,
                size: 16, color: Colors.white70),
            const SizedBox(width: 5),
            Text(
              'Answered: $answeredCount/$totalQuestions',
              style: TextStyle(
                fontSize: 14,
                color: answeredCount < totalQuestions / 2
                    ? Colors.red
                    : answeredCount < totalQuestions * 0.8
                        ? Colors.orange
                        : Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
