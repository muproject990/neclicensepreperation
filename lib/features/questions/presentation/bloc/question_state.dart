part of 'question_bloc.dart';

@immutable
sealed class QuestionState {
  get questions => null;
}

final class QuestionInitial extends QuestionState {}

final class QuestionLoading extends QuestionState {}

final class QuestionFailure extends QuestionState {
  final String error;

  QuestionFailure(this.error);
}

final class QuestionUploadSuccess extends QuestionState {}

final class QuestionDisplaySuccess extends QuestionState {
  final List<Question> questions;

  QuestionDisplaySuccess(this.questions);
}
