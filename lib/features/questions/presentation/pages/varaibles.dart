import 'dart:async';

import 'package:flutter/material.dart';
import 'package:neclicensepreperation/features/questions/domain/entities/question.dart';

class AllVaraibles {
  int desiredQuestions = 20;
  List<String?> userAnswers = [];
  List<String> correctAnswers = [];
  List<Question> selectedQuestions = [];
  late String user;

  int totalQuestions = 0;
  int correctAnswersCount = 0;
  List<int> responseTimes = [];
  DateTime? questionStartTime;

  int consecutiveCorrectAnswers = 0;
  int consecutiveIncorrectAnswers = 0;
  int difficultyThreshold = 5;
  int decreaseDifficultyThreshold = 2;
  int currentPage = 0;
  final int questionsPerPage = 10;
  late int counter = 0;
  Timer? timer;
  int remainingTime = 0;

  ValueNotifier<String> timerDisplay = ValueNotifier<String>("");
}
