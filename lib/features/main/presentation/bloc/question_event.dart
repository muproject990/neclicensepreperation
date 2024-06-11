part of 'question_bloc.dart';

@immutable
sealed class QuestionEvent {}

final class QuestionUpload extends QuestionEvent {
  final String question;
  final String option1;
  final String option2;
  final String option3;
  final String userId;
  final String option4;
  final String answer;
  final List<String> topics;

  QuestionUpload(
      {required this.question,
      required this.option1,
      required this.option2,
      required this.option3,
      required this.userId,
      required this.option4,
      required this.answer,
      required this.topics});
}

final class QuestionFetchAllQuestions extends QuestionEvent {}
