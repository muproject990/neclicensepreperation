import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuizTimer extends StatefulWidget {
  final int duration; // in seconds

  const QuizTimer({Key? key, required this.duration}) : super(key: key);

  @override
  _QuizTimerState createState() => _QuizTimerState();
}

class _QuizTimerState extends State<QuizTimer> {
  late int _remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
        // Handle timer expiration (e.g., show dialog, end quiz)
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Time is up!'),
            content: Text('You have reached the time limit.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('Time Left: $_remainingTime seconds');
  }
}
