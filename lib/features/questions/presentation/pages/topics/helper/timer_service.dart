// services/timer_service.dart

import 'dart:async';
import 'package:flutter/material.dart';

class TimerService {
  Timer? _timer;
  int _remainingTime = 0;
  ValueNotifier<String> _timerDisplay = ValueNotifier<String>("");

  ValueNotifier<String> get timerDisplay => _timerDisplay;

  void startTimer(int totalQuestions, Function onTimeUp) {
    _remainingTime = totalQuestions * 20;
    _updateTimerDisplay();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime <= 0) {
        timer.cancel();
        onTimeUp();
      } else {
        _remainingTime--;
        _updateTimerDisplay();
      }
    });
  }

  void _updateTimerDisplay() {
    int minutes = _remainingTime ~/ 60;
    int seconds = _remainingTime % 60;
    _timerDisplay.value =
        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void stopTimer() {
    _timer?.cancel();
  }
}
