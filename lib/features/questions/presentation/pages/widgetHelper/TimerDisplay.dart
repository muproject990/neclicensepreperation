import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  final ValueNotifier<String> timerDisplay;
  final int remainingTime;

  const TimerDisplay({
    Key? key,
    required this.timerDisplay,
    required this.remainingTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: timerDisplay,
      builder: (context, value, child) => Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              Icons.timer_outlined,
              color: remainingTime < 60 ? Colors.red : Colors.white,
              size: 20,
            ),
            SizedBox(width: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: remainingTime < 60 ? Colors.red : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
