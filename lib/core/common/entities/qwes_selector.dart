// services/question_selector.dart

import 'dart:math';
import 'package:neclicensepreperation/features/questions/domain/entities/question.dart';

class QuestionSelector {
  static List<Question> selectQuestionsByDifficulty(
      List<Question> allQuestions, double userAccuracy, int desiredQuestions) {
    double easyThreshold = 70.0;
    double mediumThreshold = 80.0;
    double hardThreshold = 90.0;

    List<Question> filteredQuestions;

    if (userAccuracy < easyThreshold) {
      filteredQuestions =
          allQuestions.where((q) => q.difficulty == 'easy').toList();
    } else if (userAccuracy < mediumThreshold) {
      filteredQuestions =
          allQuestions.where((q) => q.difficulty == 'medium').toList();
    } else if (userAccuracy < hardThreshold) {
      filteredQuestions =
          allQuestions.where((q) => q.difficulty == 'hard').toList();
    } else {
      filteredQuestions =
          allQuestions.where((q) => q.difficulty == 'very_hard').toList();
    }

    filteredQuestions.shuffle(Random());
    return filteredQuestions.take(desiredQuestions).toList();
  }
}
