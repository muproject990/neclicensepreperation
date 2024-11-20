import 'package:flutter/material.dart';

class TimerDisplayWidget extends StatelessWidget {
  final ValueNotifier<String> timerDisplay;
  final int remainingTime;

  const TimerDisplayWidget({
    Key? key,
    required this.timerDisplay,
    required this.remainingTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: timerDisplay,
      builder: (context, value, child) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
            const SizedBox(width: 5),
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
